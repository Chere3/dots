#!/bin/bash

# Base directory for screenshots
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

# Get current month name and year (e.g., "February 2024")
CURRENT_MONTH=$(date +"%B %Y")

# Create monthly directory if it doesn't exist
SAVE_DIR="$SCREENSHOT_DIR/$CURRENT_MONTH"
mkdir -p "$SAVE_DIR"

# Generate filename with timestamp
FILENAME="screenshot_$(date +"%Y%m%d_%H%M%S").png"
FILEPATH="$SAVE_DIR/$FILENAME"

# Function to show notification
show_notification() {
    notify-send "Screenshot" "Saved to $FILEPATH" -i "$FILEPATH"
}

# Check if grimblast is installed
if ! command -v grimblast &> /dev/null; then
    notify-send "Error" "grimblast is not installed. Install with: yay -S grimblast-git"
    exit 1
fi

# Handle different screenshot modes
case "$1" in
    "area")
        grimblast --notify --freeze copysave area "$FILEPATH"
        ;;
    "active")
        grimblast --notify --freeze copysave active "$FILEPATH"
        ;;
    "screen")
        grimblast --notify --freeze copysave screen "$FILEPATH"
        ;;
    "output")
        grimblast --notify --freeze copysave output "$FILEPATH"
        ;;
    *)
        echo "Usage: $0 [area|active|screen|output]"
        exit 1
        ;;
esac
