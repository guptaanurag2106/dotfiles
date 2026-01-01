# ~/.profile
#

if [ "$(tty)" = "/dev/tty1" ] ; then
    export QT_QPA_PLATFORM=wayland
    export MOZ_ENABLE_WAYLAND=1
    export MOZ_WEBRENDER=1
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=sway
    export _JAVA_AWT_WM_NONREPARENTING=1 # for java jar see https://wiki.archlinux.org/title/Java#Gray_window,_applications_not_resizing_with_WM,_menus_immediately_closing
    exec sway
fi

if [ -d "$HOME/.cargo/bin" ] ; then
   export PATH="$HOME/.cargo/bin:$PATH"
fi
if [ -d "$HOME/go/bin" ] ; then
   export PATH="$HOME/go/bin:$PATH"
fi
export PATH="$HOME/opt/gf:$PATH"
export PATH="${PATH}:${HOME}/.local/bin/"
