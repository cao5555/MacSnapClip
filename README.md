# MacSnapClip

A lightweight macOS Folder Action that automatically copies newly saved screenshots to the clipboard while keeping the original image files.

## Features

- Copies new screenshots to the macOS clipboard without moving or deleting the original files.
- Supports PNG, JPEG, HEIC/HEIF, and TIFF images. Non-PNG images are temporarily converted to PNG before being copied.
- Uses native macOS Folder Actions with no third-party runtime dependencies.
- Uses a folder explicitly selected and authorized by the user; no Full Disk Access grant is required for a shell.
- Runs entirely locally with no network requests, analytics, or data collection.
- Includes installation and uninstallation scripts. Uninstalling never deletes screenshots.

## Requirements

- macOS with Screenshot, Folder Actions, AppleScript, and `sips` support.
- Permission to control System Events when attaching the Folder Action.

## Installation

1. Press **Shift-Command-5**, open **Options** in the Screenshot toolbar, and choose a destination folder under **Save to**.
2. Download and unzip `MacSnapClip-v1.0.0-macos.zip` from the GitHub Release.
3. Right-click **Install.command** and choose **Open**. If Gatekeeper displays a warning, confirm that you want to open it. Alternatively, run `chmod +x Install.command` and execute it from Terminal.
4. Select the same screenshot destination folder when prompted.
5. Allow any macOS requests for System Events, Automation, or Folder Actions permissions.

The installer compiles the AppleScript source and installs `MacSnapClip.scpt` in:

```text
~/Library/Scripts/Folder Action Scripts/
```

## Usage

Press **Shift-Command-3** to capture the entire screen or **Shift-Command-4** to capture a selection. After the image has been written, press **Command-V** to paste it into another application.

A new screenshot replaces the current clipboard contents. If the destination is on an external drive, keep the drive connected. If you rename or move the destination folder, run the installer again to attach the Folder Action to the new location.

## Uninstallation

Right-click **Uninstall.command** and choose **Open**. The uninstaller removes only the Folder Action, the installed script, and the tool's configuration. It does not delete any screenshots.

## How It Works

macOS Folder Actions monitors the folder authorized during installation. When a new image arrives, the script checks whether its file size has stabilized and then writes the image to the system clipboard. Non-PNG images are converted using the built-in macOS `sips` utility, and temporary conversion files are removed afterward.

## Privacy and Security

- No network requests, analytics, tracking, or data uploads.
- No Full Disk Access requirement for a shell or terminal.
- Installation and uninstallation affect only the tool's script in `~/Library/Scripts/Folder Action Scripts/` and its configuration file at `~/Library/Preferences/com.macsnapclip.folder`.
- Release packages are not signed with a paid Apple Developer certificate or notarized. Use right-click **Open** when launching an installer for the first time.

## Project Files

```text
Install.command
Uninstall.command
Sources/MacSnapClip.applescript
LICENSE
VERSION
```

## License

Released under the MIT License. See [LICENSE](LICENSE).
