#!/bin/bash

/bin/bash -c "/usr/bin/chromium --profile-directory=Default --app=https://chat.openai.com & sleep 1.5 &&  wmctrl -r 'ChatGPT' -b add,maximized_vert,maximized_horz"
# /bin/bash -c "/opt/google/chrome/google-chrome --profile-directory=Default --app=https://chat.openai.com & sleep 1.5 &&  wmctrl -r 'ChatGPT' -b add,maximized_vert,maximized_horz"

# #Запускаємо PWA ChatGPT
# google-chrome --new-window --app=https://chat.openai.com &
#
# sleep 1.5
# wmctrl -r ChatGPT -b "add,maximized_horz,maximized_vert"
# # Очікуємо, щоб додаток запустився
#
# # Знаходимо вікно PWA ChatGPT за WM_CLASS
# WINDOW_ID=$(xdotool search --onlyvisible --class "Google-chrome")
#
# # Перевіряємо, чи знайдено вікно
# if [[ -z "$WINDOW_ID" ]]; then
#     echo "Window not found"
#     exit 1
# fi
#
# # Активуємо вікно та розгортаємо на весь екран
# xdotool windowactivate "$WINDOW_ID" windowsize "$WINDOW_ID" 100% 100%
#
# # sh -c "/opt/google/chrome/google-chrome --profile-directory=Default --app=https://chat.openai.com & sleep 0.5 &&  wmctrl -r 'ChatGPT' -b add,maximized_vert,maximized_horz"
