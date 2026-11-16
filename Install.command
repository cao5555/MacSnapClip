#!/bin/zsh

set -euo pipefail

project_dir="${0:A:h}"
source_script="$project_dir/Sources/MacSnapClip.applescript"
script_dir="$HOME/Library/Scripts/Folder Action Scripts"
installed_script="$script_dir/MacSnapClip.scpt"
config_file="$HOME/Library/Preferences/com.macsnapclip.folder"

print "MacSnapClip 安装程序"
print "截图文件仍会保留在原文件夹中，本工具只负责将新截图复制到剪贴板。"
print ""

if [[ ! -f "$source_script" ]]; then
    print -u2 "错误：找不到源脚本 $source_script"
    exit 1
fi

if [[ -n "${SCREENSHOT_CLIPBOARD_FOLDER:-}" ]]; then
    screenshot_folder="$SCREENSHOT_CLIPBOARD_FOLDER"
else
    screenshot_folder="$(/usr/bin/osascript -e 'POSIX path of (choose folder with prompt "选择 macOS 截图保存文件夹")')"
fi

screenshot_folder="${screenshot_folder%/}"
if [[ ! -d "$screenshot_folder" ]]; then
    print -u2 "错误：文件夹不存在：$screenshot_folder"
    exit 1
fi

mkdir -p "$script_dir"
osacompile -o "$installed_script" "$source_script"

/usr/bin/osascript - "$screenshot_folder" "$installed_script" <<'APPLESCRIPT'
on run argv
    set folder_alias to POSIX file (item 1 of argv) as alias
    set script_alias to POSIX file (item 2 of argv) as alias
    tell application "System Events"
        set folder actions enabled to true
        try
            detach action from folder_alias using script_alias
        end try
        attach action to folder_alias using script_alias
    end tell
end run
APPLESCRIPT

printf '%s\n' "$screenshot_folder" > "$config_file"

print ""
print "安装完成。新截图保存到以下文件夹后会自动复制到剪贴板："
print "$screenshot_folder"
print "如系统请求“系统事件”或“文件夹操作”权限，请允许。"
