#!/bin/zsh

# Starts a scan of available broadcasting SSIDs
# nmcli dev wifi rescan

FIELDS=SSID,BARS

LIST=$(nmcli --fields "$FIELDS" device wifi list | sed '/^--/d')
# For some reason rofi always approximates character width 2 short... hmmm
RWIDTH=$(($(echo "$LIST" | head -n 1 | awk '{print length($0); }') + 2))
# Dynamically change the height of the rofi menu
LINENUM=$(echo "$LIST" | wc -l)
# Gives a list of known connections so we can parse it later
KNOWNCON=$(nmcli connection show)
# echo $KNOWNCON
# Really janky way of telling if there is currently a connection
CONSTATE=$(nmcli -fields WIFI g)

CURRSSID=$(iwgetid -r)

if [[ ! -z $CURRSSID ]]; then
    HIGHLINE=$(echo "$(echo "$LIST" | awk -F "[  ]{2,}" '{print $1}' | grep -Fxn -m 1 "$CURRSSID" | awk -F ":" '{print $1}') + 1" | bc)
fi

# HOPEFULLY you won't need this as often as I do
# If there are more than 8 SSIDs, the menu will still only have 8 lines
if [ "$LINENUM" -gt 8 ] && [[ "$CONSTATE" =~ "enabled" ]]; then
    LINENUM=8
elif [[ "$CONSTATE" =~ "disabled" ]]; then
    LINENUM=1
fi

if [[ "$CONSTATE" =~ "enabled" ]]; then
    TOGGLE="toggle off"
elif [[ "$CONSTATE" =~ "disabled" ]]; then
    TOGGLE="toggle on"
fi

# CHENTRY=$(echo -e "$TOGGLE\nmanual\n$LIST" | uniq -u | rofi -dmenu -p "Wi-Fi SSID: " -lines "$LINENUM" -a "$HIGHLINE" -location "$POSITION" -yoffset "$YOFF" -xoffset "$XOFF" -font "$FONT" -width -"$RWIDTH")
CHENTRY=$(echo -e "$TOGGLE\nmanual\n$LIST" | uniq -u | rofi -dmenu -p "Wi-Fi SSID: " -lines "$LINENUM" -a "$HIGHLINE" -theme "~/.local/share/rofi/themes/bluetooth.rasi")
#echo "$CHENTRY"
CHSSID=$(echo "$CHENTRY" | sed 's/\s\{2,\}/\|/g' | awk -F "|" '{print $1}')
# echo "$CHSSID"

# If the user inputs "manual" as their SSID in the start window, it will bring them to this screen
if [ "$CHENTRY" = "manual" ]; then
    # Manual entry of the SSID and password (if appplicable)
    MSSID=$(echo "enter the SSID of the network (SSID,password)" | rofi -dmenu -p "Manual Entry: " -lines 1 -theme "~/.local/share/rofi/themes/bluetooth.rasi")
    # Separating the password from the entered string
    MPASS=$(echo "$MSSID" | awk -F "," '{print $2}')

    #echo "$MSSID"
    #echo "$MPASS"

    # If the user entered a manual password, then use the password nmcli command
    if [ "$MPASS" = "" ]; then
        nmcli dev wifi con "$MSSID"
    else
        nmcli dev wifi con "$MSSID" password "$MPASS"
    fi

elif [ "$CHENTRY" = "toggle on" ]; then
    nmcli radio wifi on

elif [ "$CHENTRY" = "toggle off" ]; then
    nmcli radio wifi off

else

    # If the connection is already in use, then this will still be able to get the SSID
    if [[ "$CHSSID" =~ "$CURRSSID" ]]; then
        exit
    fi

    # Parses the list of preconfigured connections to see if it already contains the chosen SSID. This speeds up the connection process
    if [[ $(echo "$KNOWNCON" | grep "$CHSSID") =~ "$CHSSID" ]]; then
        nmcli connection up "$CHSSID"
    else
        if [[ "$CHENTRY" =~ "▂" ]]; then
            WIFIPASS=$(echo "if connection is stored, hit enter" | rofi -dmenu -p "password: " -lines 1 -theme "~/.local/share/rofi/themes/bluetooth.rasi")
            echo $WIFIPASS
        fi
        nmcli connection add type wifi ifname wlp0s20f3 con-name "$CHSSID" ssid "$CHSSID"
        nmcli connection modify "$CHSSID" wifi-sec.key-mgmt wpa-psk
        nmcli connection modify "$CHSSID" wifi-sec.psk "$WIFIPASS"
        nmcli connection up "$CHSSID"
    fi

fi
