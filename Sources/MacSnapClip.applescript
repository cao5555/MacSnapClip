on adding folder items to this_folder after receiving added_items
    repeat with current_item in added_items
        try
            set item_alias to current_item as alias
            set item_path to POSIX path of item_alias
            if my is_supported_image(item_path) then
                my copy_when_stable(item_alias, item_path)
            end if
        on error error_message
            log "MacSnapClip: " & error_message
        end try
    end repeat
end adding folder items to

on is_supported_image(item_path)
    ignoring case
        if item_path ends with ".png" then return true
        if item_path ends with ".jpg" then return true
        if item_path ends with ".jpeg" then return true
        if item_path ends with ".heic" then return true
        if item_path ends with ".heif" then return true
        if item_path ends with ".tif" then return true
        if item_path ends with ".tiff" then return true
    end ignoring
    return false
end is_supported_image

on copy_when_stable(item_alias, item_path)
    set previous_size to -1
    repeat 12 times
        set current_size to size of (info for item_alias)
        if current_size > 0 and current_size is previous_size then
            my copy_image(item_alias, item_path)
            return
        end if
        set previous_size to current_size
        delay 0.5
    end repeat
    error "The image did not become stable in time: " & item_path
end copy_when_stable

on copy_image(item_alias, item_path)
    ignoring case
        set is_png to item_path ends with ".png"
    end ignoring

    if is_png then
        set the clipboard to (read item_alias as «class PNGf»)
        return
    end if

    set temp_path to "/tmp/MacSnapClip-" & (random number from 100000 to 999999) & ".png"
    try
        do shell script "/usr/bin/sips -s format png " & quoted form of item_path & " --out " & quoted form of temp_path & " >/dev/null 2>&1"
        set the clipboard to (read (POSIX file temp_path as alias) as «class PNGf»)
        do shell script "/bin/rm -f " & quoted form of temp_path
    on error error_message
        try
            do shell script "/bin/rm -f " & quoted form of temp_path
        end try
        error error_message
    end try
end copy_image
