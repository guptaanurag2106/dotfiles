#!/usr/bin/env bash
set -e

# -----------------------
# wf-recorder + converter
# -----------------------
# Usage examples:
#   wfrecord                 # recording-2026-01-21_15-02-11.mp4 (no audio)
#   wfrecord --audio          # include system audio
#   wfrecord --audio demo.mkv
#   wfrecord clip.gif
# -----------------------

AUDIO_FLAG=""
if [[ "$1" == "--audio" ]]; then
    AUDIO_FLAG="--audio"
    shift
fi

INPUT="$1"
if [[ -z "$INPUT" ]]; then
    NAME="recording"
    EXT="mp4"
else
    if [[ "$INPUT" == *.* ]]; then
        NAME="${INPUT%.*}"
        EXT="${INPUT##*.}"
    else
        NAME="$INPUT"
        EXT="mp4"
    fi
fi

TIMESTAMP="$(date +'%F_%H-%M-%S')"
RAW_FILE="${NAME}-${TIMESTAMP}.mp4"
OUT_FILE="${NAME}-${TIMESTAMP}.${EXT}"

echo "Select region to record"
wf-recorder -g "$(slurp)" $AUDIO_FLAG -f "$RAW_FILE"

# if [[ "$EXT" == "mp4" ]]; then
#     mv "$RAW_FILE" "$OUT_FILE"
#     echo "Saved as $OUT_FILE"
#     exit 0
# fi

if [[ "$EXT" == "mkv" ]]; then
    ffmpeg -y -i "$RAW_FILE" -c:v ffv1 -c:a copy "$OUT_FILE"
    rm "$RAW_FILE"
    echo "Saved as $OUT_FILE"
    exit 0
fi

if [[ "$EXT" == "gif" ]]; then
    PALETTE=$(mktemp /tmp/palette-XXXX.png)
    ffmpeg -y -i "$RAW_FILE" -vf "fps=15,scale=iw/2:-1:flags=lanczos,palettegen" "$PALETTE"
    ffmpeg -y -i "$RAW_FILE" -i "$PALETTE" -lavfi "fps=15,scale=iw/2:-1:flags=lanczos[x];[x][1:v]paletteuse" "$OUT_FILE"
    rm "$RAW_FILE" "$PALETTE"
    echo "Saved as $OUT_FILE"
    exit 0
fi

# mv "$RAW_FILE" "$OUT_FILE"
echo "Saved as $OUT_FILE"

