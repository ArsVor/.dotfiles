#!/usr/bin/env bash

sh -c "/opt/google/chrome/google-chrome --profile-directory=Default --app=https://outlook.live.com/mail/1/ & sleep 0.5 &&  wmctrl -r 'Outlook' -b add,maximized_vert,maximized_horz"

