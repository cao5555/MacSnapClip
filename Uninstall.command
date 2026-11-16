#!/bin/zsh

set -euo pipefail

script_dir="$HOME/Library/Scripts/Folder Action Scripts"
installed_script="$script_dir/MacSnapClip.scpt"
config_file="$HOME/Library/Preferences/com.macsnapclip.folder"

if [[ -f "$config_file" && -f "$installed_script" ]]; then
    screenshot_folder="$(head -n 1 "$config_file")"
    if [[ -d "$screenshot_folder" ]]; then
        /usr/bin/osascript - "$screenshot_folder" "$installed_script" <<'APPLESCRIPT'
on run argv
    set folder_alias to POSIX file (item 1 of argv) as alias
    set script_alias to POSIX file (item 2 of argv) as alias
    tell application "System Events"
        try
            detach action from folder_alias using script_alias
        end try
    end tell
end run
APPLESCRIPT
    fi
fi

rm -f "$installed_script" "$config_file"

print "MacSnapClip 已卸载。所有截图文件均已保留。"
