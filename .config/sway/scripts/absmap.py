#!/usr/bin/env python3

import os
import sys
import yaml
import subprocess
import time
from evdev import InputDevice, UInput, ecodes, list_devices

RETRY_TIME = 3  # in sec


def find_device(config):
    """Find device by path or name"""
    device_config = config.get("device", {})

    if "path" in device_config:
        path = device_config["path"]
        if not os.path.isfile(path):
            raise ValueError(f"Device path not found: {path}")
        if os.path.islink(path):
            return os.readlink(path)
        else:
            return path

    elif "name" in device_config:
        name_substr = device_config["name"].lower()
        for dev_path in list_devices():
            dev = InputDevice(dev_path)
            if name_substr in dev.name.lower():
                # print(f"Found device: {dev.name} at {dev_path}")
                return dev_path
        raise ValueError(f"No device found matching name: {name_substr}")

    else:
        raise ValueError(
            "Config must specify either 'device.path' or 'device.name'"
        )


def validate_config(config):
    """Validate configuration"""
    errors = []

    if "device" not in config:
        errors.append("Missing 'device' section")
    if "axis" not in config:
        errors.append("Missing 'axis' field")
    if "gestures" not in config:
        errors.append("Missing 'gestures' section")

    if errors:
        return errors

    # Validate gestures
    gestures = config.get("gestures", {})

    if "up" in gestures:
        if "action" not in gestures["up"]:
            errors.append("Gesture 'up': missing 'action'")
        else:
            if (
                "keys" not in gestures["up"]["action"]
                and "command" not in gestures["up"]["action"]
            ):
                errors.append(
                    "Action for gesture 'up': missing 'keys/command'"
                )

    if "down" in gestures:
        if "action" not in gestures["down"]:
            errors.append("Gesture 'down': missing 'action'")
        else:
            if (
                "keys" not in gestures["down"]["action"]
                and "command" not in gestures["down"]["action"]
            ):
                errors.append(
                    "Action for gesture 'down': missing 'keys/command'"
                )

    return errors


def get_axis_code(axis_name):
    """Convert axis name string to evdev code"""
    axis_map = {
        "ABS_RX": ecodes.ABS_RX,
        "ABS_RY": ecodes.ABS_RY,
        "ABS_WHEEL": ecodes.ABS_WHEEL,
        # 'ABS_THROTTLE': ecodes.ABS_THROTTLE,
        # 'ABS_MISC': ecodes.ABS_MISC,
    }

    code = axis_map.get(axis_name)
    if code is None:
        raise ValueError(
            f"Unknown axis: {axis_name}. "
            f"Supported: {', '.join(axis_map.keys())}"
        )
    return code


def parse_key(key_str):
    """Parse key string to evdev keycode

    Supports:
    - Direct keycode: "28" or 28
    - KEY_ constant: "KEY_ENTER"
    - Common names: "enter", "space", "ctrl", etc.
    """
    # If it's an integer, use directly
    if isinstance(key_str, int):
        return key_str

    key_str = str(key_str).strip().upper()

    # Try as direct number
    try:
        return int(key_str)
    except ValueError:
        pass

    # Try with KEY_ prefix if not present
    if not key_str.startswith("KEY_"):
        key_str = "KEY_" + key_str

    # Look up in ecodes
    keycode = getattr(ecodes, key_str, None)
    if keycode is None:
        raise ValueError(f"Unknown key: {key_str}")

    return keycode


def emit_keys(uinput, keys, key_delay):
    """Emit key press and release events"""
    if not isinstance(keys, list):
        keys = [keys]

    # Parse all keys first
    keycodes = [parse_key(k) for k in keys]

    # Press all keys
    for keycode in keycodes:
        uinput.write(ecodes.EV_KEY, keycode, 1)
    uinput.syn()

    # Small delay for key registration
    time.sleep(key_delay / 1000)

    # Release all keys
    for keycode in keycodes:
        uinput.write(ecodes.EV_KEY, keycode, 0)
    uinput.syn()


def execute_action(action, uinput, key_delay):
    """Execute action - either emit keys or run command

    Action can be:
    - keys: [KEY_A] or keys: KEY_A
    - command: "some shell command"
    """
    if isinstance(action, dict):
        if "keys" in action:
            try:
                emit_keys(uinput, action["keys"], key_delay)
            except Exception as e:
                print(f"Key emit error: {e}", file=sys.stderr)

        elif "command" in action:
            try:
                subprocess.run(
                    action["command"],
                    shell=True,
                    capture_output=True,
                    timeout=1,
                )
            except Exception as e:
                print(f"Command error: {e}", file=sys.stderr)
        else:
            print(f"Invalid action: {action}", file=sys.stderr)
    else:
        print(f"Invalid action type: {action}", file=sys.stderr)


class VelocityTracker:
    """Track velocity and acceleration of strip movement"""

    def __init__(self, velocity_threshold, acceleration_enabled, history_size):
        self.velocity_threshold = velocity_threshold
        self.acceleration_enabled = acceleration_enabled
        self.history = []  # [(timestamp, value), ...]
        self.max_history = history_size

    def add_sample(self, timestamp, value):
        """Add a new sample and trim history"""

        # Ignore value 0 (spurious touch/lift events)
        # TODO: do actions on keydown/up
        if value == 0:
            self.clear()
            return

        self.history.append((timestamp, value))
        if len(self.history) > self.max_history:
            self.history.pop(0)

    def get_velocity(self):
        """Calculate velocity (units per second)"""
        if len(self.history) < 2:
            return 0.0

        t1, v1 = self.history[0]
        t2, v2 = self.history[-1]

        dt = t2 - t1
        if dt == 0:
            return 0.0

        dv = v2 - v1
        return dv / dt

    def get_acceleration(self):
        """Calculate acceleration (units per second²)"""
        if not self.acceleration_enabled or len(self.history) < 3:
            return 0.0

        # Calculate velocity at two different points
        t1, v1 = self.history[0]
        t2, v2 = self.history[len(self.history) // 2]
        t3, v3 = self.history[-1]

        dt1 = t2 - t1
        dt2 = t3 - t2

        if dt1 == 0 or dt2 == 0:
            return 0.0

        vel1 = (v2 - v1) / dt1
        vel2 = (v3 - v2) / dt2

        return (vel2 - vel1) / ((dt1 + dt2) / 2)

    def detect_gesture(self):
        """Detect if gesture threshold is met

        Returns: 'up', 'down', or None
        """
        if len(self.history) < 2:
            return None

        velocity = self.get_velocity()
        self.velocity = velocity  # Always set velocity
        # print(f'     {self.velocity}') # Removed debugging print
        abs_velocity = abs(self.velocity)

        # Check if self.velocity exceeds threshold
        if abs_velocity < self.velocity_threshold:
            self.acceleration = 0.0  # Also set acceleration
            return None

        # Acceleration multiplier (if enabled)
        multiplier = 1.0
        if self.acceleration_enabled:
            accel = self.get_acceleration()
            self.acceleration = accel  # Always set acceleration if enabled
            # Increase threshold if decelerating, decrease if accelerating
            if self.velocity > 0 and self.acceleration < 0:
                multiplier = 1.5
            elif self.velocity < 0 and self.acceleration > 0:
                multiplier = 1.5
            elif self.velocity > 0 and self.acceleration > 0:
                multiplier = 0.7
            elif self.velocity < 0 and self.acceleration < 0:
                multiplier = 0.7
        else:
            self.acceleration = 0.0  # Set acceleration to 0 if not enabled

        threshold = self.velocity_threshold * multiplier

        if abs_velocity < threshold:
            return None

        return "up" if self.velocity > 0 else "down"

    def clear(self):
        """Clear history"""
        self.history.clear()


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <config.yaml>", file=sys.stderr)
        sys.exit(1)

    config_path = sys.argv[1]

    try:
        with open(config_path, "r") as f:
            config = yaml.safe_load(f)
    except FileNotFoundError:
        print(f"Config file not found: '{config_path}'", file=sys.stderr)
        sys.exit(1)
    except yaml.YAMLError as e:
        print(f"Config parse error: {e}", file=sys.stderr)
        sys.exit(1)

    errors = validate_config(config)
    if errors:
        print(f"Invalid config at '{config_path}':", file=sys.stderr)
        for error in errors:
            print(f"  - {error}", file=sys.stderr)
        sys.exit(1)

    try:
        axis_code = get_axis_code(config["axis"])
    except ValueError as e:
        print(f"Config error: {e}", file=sys.stderr)
        sys.exit(1)

    # Get settings
    settings = config.get("settings", {})
    velocity_threshold = settings.get("velocity_threshold", 3.0)
    acceleration = settings.get("acceleration", False)
    cooldown_ms = settings.get("cooldown", 300)
    key_delay_ms = settings.get("key_delay", 5)
    history_size = settings.get("history_size", 5)
    grab = settings.get("grab", True)

    gestures = config["gestures"]

    # print(f"Listening on axis {config['axis']}")
    # print("Settings: ")
    # print(f"         velocity threshold: {velocity_threshold}")
    # print(f"         acceleration      : {acceleration}")
    # print(f"         cooldown in ms    : {cooldown_ms}")
    # print(f"         key delay in ms   : {key_delay_ms}")
    # print(f"         history size      : {history_size}")
    # print(f"         grab              : {grab}")

    # Create virtual input device ONCE (persistent across reconnects)
    try:
        uinput = UInput(name="absmap")
    except OSError as e:
        print(f"Could not create virtual device: {e}", file=sys.stderr)
        sys.exit(1)

    # Velocity tracker
    tracker = VelocityTracker(velocity_threshold, acceleration, history_size)
    last_gesture_time = 0

    wait_for_device_print = False

    while True:
        device = None
        try:
            # Attempt to Find and Connect
            try:
                device_path = find_device(config)
                device = InputDevice(device_path)
            except (ValueError, OSError) as e:
                if not wait_for_device_print:
                    print(f"Waiting for device... ({e})")
                    wait_for_device_print = True
                time.sleep(RETRY_TIME)
                continue

            print(f"Connected to '{device.name}' at '{device_path}'")
            wait_for_device_print = False

            # Grab Device (Fatal if fails - permission issue)
            if grab:
                try:
                    device.grab()
                    print(f"Grabbed exclusive access to '{device.name}'")
                except OSError as e:
                    print(
                        f"Could not grab device '{device.name}': {e}",
                        file=sys.stderr,
                    )
                    sys.exit(1)

            for event in device.read_loop():
                # Only process absolute axis events for our configured axis
                if event.type == ecodes.EV_ABS and event.code == axis_code:
                    value = event.value
                    timestamp = event.timestamp()

                    tracker.add_sample(timestamp, value)
                    gesture = tracker.detect_gesture()

                    if gesture is not None:
                        current_time = time.time() * 1000
                        if current_time - last_gesture_time < cooldown_ms:
                            continue

                        if gesture in gestures:
                            gesture_config = gestures[gesture]
                            action = gesture_config.get("action")
                            last_gesture_time = current_time

                            if action:
                                execute_action(action, uinput, key_delay_ms)
                                tracker.clear()

        except OSError as e:
            print(f"Device disconnected: {e}")
        except KeyboardInterrupt:
            print("\nExiting...")
            break
        except Exception as e:
            print(f"Unexpected error: {e}", file=sys.stderr)
            import traceback

            traceback.print_exc()
            time.sleep(RETRY_TIME)
        finally:
            if device:
                if grab:
                    try:
                        device.ungrab()
                    except Exception:
                        pass
                try:
                    device.close()
                except Exception:
                    pass

            tracker.clear()

    uinput.close()


if __name__ == "__main__":
    main()
