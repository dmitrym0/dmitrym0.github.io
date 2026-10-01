+++
title = "Automatic Do not disturb mode for iPhone while in Google Meet"
author = ["Dmitry Markushevich"]
date = 2025-01-04
lastmod = 2026-10-01T13:01:28-07:00
tags = ["misc"]
draft = false
+++

I've been using Bose QuietComfort35s since 2017. I use it both for music, connected to my iPhone and for work calls. One issue is that when a call comes through on my phone, the audio is disconnected from my Macbook. This is very inconvenient during a work Google Meet call. I have to scramble then to reconnect the audio to my meeting.

I'm fixing this with an AppleScript + Apple Shortcut combo.

Available as a [gist](https://gist.github.com/dmitrym0/536a37319322fb39307d3a925f8c98e0).

```applescript
 on run
    tell application "Brave Browser"
        activate
        set i to 0
        repeat with w in (windows) -- loop over each window
            repeat with t in (tabs of w) -- loop over each tab
                if title of t starts with "Meet" then
                    tell application "Shortcuts"
                            # dnd for 10 mins
                            run shortcut "macos-focus-mode" with input "10"
                    end tell
                    do shell script "~/bin/hs_message 'DND'"
                    return
                end if
            end repeat
        end repeat
    end tell
end run
```

The apple script looks for my browser, and then tries to identify the tab that contain the Google Meet meeting.
If one is found, it executes the shortcut to set "Do not disturb" mode for 10 minutes.

I have it running every 3 minutes via launchd:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.dnd-for-meet</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/osascript</string>
        <string>~/bin/enable-dnd-for-google-meet.scpt</string>
    </array>
    <key>StartInterval</key>
    <integer>180</integer>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
```

The idea is is that if a meeting is ongoing, DND mode will keep being extended by 10 minutes and should cover the duration of the meeting.

To install:

1.  Grab the shortcut from [here](https://github.com/arodik/macos-focus-mode).
2.  Grab the applescript from the [gist](https://gist.github.com/dmitrym0/536a37319322fb39307d3a925f8c98e0) and store it locally. You might want to change it for your browser.
3.  Create a launchd config in `~/Library/LaunchAgents/com.user.dnd-for-meet.plist`.
4.  Load the config like so `launchctl load ~/Library/LaunchAgents/com.user.dnd-for-meet.plist`.
