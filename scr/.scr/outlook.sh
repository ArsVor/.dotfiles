#!/usr/bin/env bash

# sh -c "/opt/microsoft/msedge/microsoft-edge --profile-directory=Default --app=https://outlook.live.com/mail/1/ & sleep 0.5 &&  wmctrl -r 'Outlook' -b add,maximized_vert,maximized_horz"
sh -c "/usr/bin/microsoft-edge-stable --profile-directory=Default --app=https://outlook.live.com/mail/1/ & sleep 0.5 &&  wmctrl -r 'Outlook' -b add,maximized_vert,maximized_horz"
