# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess

from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy

mod = "mod4"
modkey = "mod1"
terminal = "kitty"
calculator = "gnome-calculator"
calendar = "gnome-calendar"
# browser = ""
browser = "zen-browser"
gpt_chat = "gpt"
google_translate = "tsl"
mail = "thunderbird"


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.call(home)
    # subprocess.Popen(["libinput-gestures-setup", "start"])


@hook.subscribe.client_managed
def move_to_current_group(window):
    current_group = window.qtile.current_group
    if window.group != current_group:
        window.togroup(current_group.name, switch_group=False)


previous_layouts = [""] * 9


def toggle_max_layout(qtile):
    current_layout = qtile.current_layout.name
    current_group = int(qtile.current_group.name)

    if current_layout == "max":
        previous_layout = previous_layouts[current_group - 1]
        qtile.current_group.setlayout(previous_layout)
    else:
        previous_layouts[current_group - 1] = current_layout
        qtile.current_group.setlayout("max")


def alter_column_switch_focus(qtile, direction):
    current_layout = qtile.current_layout.name

    if current_layout != "columns":
        return

    qtile.current_layout.next()
    if direction == "up":
        qtile.current_layout.up()
    elif direction == "down":
        qtile.current_layout.down()
    else:
        return
    qtile.current_layout.next()


groups = [Group(i) for i in "123456789"]
custom_keys = []
for i in groups:
    custom_keys.extend(
        [
            # mod + shift + group number = switch to & move focused window to group
            Key(
                ["shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
            # mod group number = move focused window to group
            Key(
                [],
                i.name,
                lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name),
            ),
        ]
    )

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key(
        [mod, "shift"],
        "p",
        lazy.spawn("sh -c '~/.config/qtile/src/rofi-power-menu.sh'"),
        desc="Power menu",
    ),
    # Switch group (outher added in for loop)
    Key(
        [mod, "control"],
        "left",
        lazy.screen.prev_group(),
        desc="Move focus to previous group",
    ),
    Key(
        [mod, "control"],
        "right",
        lazy.screen.next_group(),
        desc="Move focus to next group",
    ),
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    # Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key(
        [mod],
        "space",
        lazy.widget["keyboardlayout"].next_keyboard(),
        desc="Next keyboard layout",
    ),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod],
        "z",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key(
        [mod, "mod1"],
        "k",
        lazy.function(lambda qtile: alter_column_switch_focus(qtile, "up")),
        desc="Focus up in alter stack",
    ),
    Key(
        [mod, "mod1"],
        "j",
        lazy.function(lambda qtile: alter_column_switch_focus(qtile, "down")),
        desc="Focus down in alter stack",
    ),
    # MonadTall keybindings
    Key([modkey], "i", lazy.layout.grow()),
    Key([modkey], "m", lazy.layout.shrink()),
    Key([modkey], "n", lazy.layout.reset()),
    Key([modkey], "o", lazy.layout.maximize()),
    Key([modkey, "shift"], "s", lazy.layout.toggle_auto_maximize()),
    Key([modkey, "shift"], "space", lazy.layout.flip()),
    # Toggle between different layouts as defined below
    Key([mod, "control"], "n", lazy.next_layout(), desc="Next layouts"),
    Key([mod, "control"], "p", lazy.prev_layout(), desc="Previous layouts"),
    Key([mod], "Tab", lazy.function(toggle_max_layout), desc="Toggle Max layout"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "v",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key(["mod1"], "tab", lazy.spawn("rofi -show window")),
    # Run and quit
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "mod1"], "space", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "Return", lazy.spawn("rofi -show drun"), desc="Launch drun"),
    Key([mod], "a", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "b", lazy.spawn(browser), desc="Launch browser"),
    Key([mod], "c", lazy.spawn(calculator), desc="Launch calculator"),
    Key([mod], "g", lazy.spawn(gpt_chat), desc="Launch gpt_chat"),
    Key([mod], "m", lazy.spawn(mail), desc="Launch mail"),
    Key([mod], "o", lazy.spawn("obsidian"), desc="Launch obsidian"),
    Key([mod, "shift"], "s", lazy.spawn("flameshot gui"), desc="Screenshot"),
    Key([mod], "t", lazy.spawn(google_translate), desc="Launch google_translate"),
    KeyChord(
        [mod],
        "e",
        [
            Key([], "b", lazy.spawn("brave"), desc="Launch Brave browser"),
            Key([], "c", lazy.spawn("gcolor3"), desc="Launch Color picker"),
            Key(["shift"], "c", lazy.spawn("gnome-contacts"), desc="Launch Contacts"),
            Key([], "d", lazy.spawn(calendar), desc="Launch Calendar"),
            Key(
                [],
                "e",
                lazy.spawn("microsoft-edge-stable"),
                desc="Launch Microsoft-edge",
            ),
            Key([], "f", lazy.spawn("nautilus"), desc="Launch Nautilus"),
            Key([], "g", lazy.spawn("google-chrome"), desc="Launch Google chrome"),
            Key([], "m", lazy.spawn("gnome-maps"), desc="Launch Maps"),
            Key([], "q", lazy.spawn("qutebrowser"), desc="Launch Qutebrowser"),
            Key(
                [],
                "s",
                lazy.spawn("gnome-system-monitor"),
                desc="Launch System monitor",
            ),
            Key([], "t", lazy.spawn("gnome-text-editor"), desc="Launch Text editor"),
            Key([], "v", lazy.spawn("code"), desc="Launch VSCode"),
            Key([], "w", lazy.spawn("gnome-weather"), desc="Launch Weather"),
        ],
        name="E",
    ),
    KeyChord(
        [mod],
        "p",
        [
            Key([], "l", lazy.spawn("xautolock -locknow"), desc="[L]ock screen"),
            Key([], "s", lazy.spawn("systemctl suspend"), desc="[S]uspend"),
            Key([], "q", lazy.shutdown(), desc="Shutdown [Q]tile"),
            Key([], "r", lazy.spawn("systemctl reboot"), desc="[R]eboot"),
            Key([], "o", lazy.spawn("systemctl poweroff"), desc="Power [O]ff"),
        ],
        name="P",
    ),
    KeyChord(
        [mod],
        "r",
        [
            Key(
                [],
                "c",
                lazy.spawn("zsh -c ~/.config/qtile/src/rofi-config-files.sh &"),
                desc="Open .dotfiles",
            ),
            Key([], "e", lazy.spawn("rofi -show drun"), desc="Launch drun"),
            Key([], "s", lazy.spawn("rofi -show ssh"), desc="Launch ssh connector"),
            Key([], "r", lazy.spawn("rofi -show run"), desc="Launch executable"),
        ],
        name="R",
    ),
    KeyChord(
        [mod],
        "w",
        custom_keys,
        name="W",
    ),
    KeyChord(
        [mod],
        "y",
        [
            Key([], "c", lazy.group.setlayout("columns")),
            Key([], "l", lazy.group.setlayout("tile")),
            Key([], "m", lazy.group.setlayout("monadtall")),
            Key([], "t", lazy.group.setlayout("treetab")),
            Key([], "w", lazy.group.setlayout("monadwide")),
            Key([], "z", lazy.group.setlayout("zoomy")),
        ],
        name="Y",
    ),
    #### Multimedia keys ####
    # Volume
    Key([], "XF86AudioMute", lazy.spawn("pamixer -t")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 5")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer -d 5")),
    Key([], "XF86AudioMicMute", lazy.spawn("pamixer --default-source -t")),
    # Key([mod], "XF86AudioRaiseVolume", lazy.spawn("pamixer --default-source -i 5")),
    # Key([mod], "XF86AudioLowerVolume", lazy.spawn("pamixer --default-source -d 5")),
    # Play
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioStop", lazy.spawn("playerctl stop")),
    # brightnes
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +5%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-")),
    # Outher
    Key([], "XF86Calculator", lazy.spawn(calculator)),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            # Key(
            #     [mod, "shift"],
            #     i.name,
            #     lazy.window.togroup(i.name, switch_group=True),
            #     desc=f"Switch to & move focused window to group {i.name}",
            # ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )


leyout_theme = {
    "border_width": 3,
    "margin": 15,
    "border_focus": "ffffff",
    "border_normal": "CCCCCC",
}

layouts = [
    layout.Columns(
        border_focus=["#3a515d", "#7fbbb3"],
        border_normal="#232a2e",
        border_normal_stack="#425047",
        border_focus_stack=["#83c092", "#a7c080"],
        border_width=3,
        margin=15,
    ),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(
        min_secondary_size=10,
    ),
    layout.MonadWide(),
    # layout.RatioTile(),
    layout.Tile(),
    layout.TreeTab(),
    # layout.VerticalTile(),
    layout.Zoomy(),
    layout.Max(),
]

widget_defaults = dict(
    font="JetBrainsMono Nerd Font Bold Italic",
    fontsize=22,
    foreground="#d3c6aa",
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Sep(
                    linewidth=0,
                    padding=6,
                ),
                widget.CurrentLayoutIcon(),
                # widget.CurrentLayout(),
                widget.GroupBox(
                    active="#d3c6aa",
                    highlight_color=["#00000090", "#7fbbb3"],
                    highlight_method="line",
                ),
                widget.Prompt(),
                # widget.WindowName(),
                widget.Spacer(length=bar.STRETCH),
                widget.Clock(
                    format="%a %d %b %H:%M",
                    mouse_callbacks={
                        "Button1": lazy.spawn(calendar),
                        "Button3": lazy.spawn(
                            "zsh -c ~/.config/qtile/src/weather_mouse_callbeck.sh"
                        ),
                    },
                ),
                widget.Spacer(length=bar.STRETCH),
                widget.Chord(
                    fmt="{{{}}}",
                    chords_colors={
                        "P": ("#00000090", "#e67e80"),
                        "E": ("#00000090", "#7fbbb3"),
                        "R": ("#00000090", "#3a515d"),
                        "W": ("#00000090", "#e69875"),
                        "Y": ("#00000090", "#a7c080"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # widget.Systray(),
                widget.KeyboardLayout(
                    configured_keyboards=["us", "ua"],
                    display_map={"us": " en", "ua": " uk"},
                ),
                widget.CheckUpdates(
                    colour_have_updates="#e67e80",
                    # custom_command="pikaur -Qu ",
                    custom_command="updatecheck",
                    display_format="   {updates}",
                    update_interval=7200,
                    mouse_callbacks={
                        "Button1": lazy.spawn(
                            "zsh -c ~/.config/qtile/src/qtile_update.sh"
                        )
                    },
                ),
                # widget.Sep(),
                widget.CPU(
                    # background="#56635f90",
                    foreground="#7fbbb3",
                    format="   {load_percent}%",
                ),
                # widget.Sep(),
                widget.Memory(
                    foreground="#e69875",
                    format="   {MemPercent}%",
                ),
                # widget.Sep(),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Battery(
                    foreground="#a7c080",
                    full_char="󰁹",
                    empty_char="󰂎",
                    charge_char="󰂄",
                    discharge_char="󰁿",
                    not_charging_char="󰂂",
                    unknown_char="󰂑",
                    low_foreground="#e67e80",
                    format=" {char} {percent:2.0%}",
                    low_percentage=0.2,
                    show_short_text=False,
                ),
                widget.PulseVolume(
                    # emoji=True,
                    mute_format="   ",
                    unmute_format="  {volume}%",
                    foreground="#dbbc7f",
                ),
                widget.WidgetBox(
                    widgets=[
                        widget.Sep(),
                        widget.Bluetooth(
                            foreground="#7fbbb3",
                            adapter_format="{powered}{name} ",
                            device_format="{symbol}{name} {battery_level} ",
                            device_battery_format="(󰥉{battery}%)",
                            default_text="  {num_connected_devices} ",
                            default_show_battery=True,
                            symbol_powered=(" 󰂰 ", " 󰂲 "),
                            symbol_connected=" 󰂰 ",
                            symbol_paired=" 󰂲 ",
                            symbol_discovery=(" 󰂱 ", "  "),
                            update_interval=5,
                            mouse_callbacks={
                                "Button1": lazy.spawn(
                                    "rofi-bluetooth -theme ~/.local/share/rofi/themes/bluetooth.rasi &"
                                )
                            },
                        ),
                        widget.Sep(),
                        widget.Wlan(
                            foreground="#83c092",
                            interface="wlxac5afc411153",
                            format=" 󱚻 ",
                            disconnected_message=" 󰖪 ",
                            update_interval=5,
                            mouse_callbacks={
                                "Button1": lazy.spawn(
                                    "zsh -c ~/.config/qtile/src/rofi-wifi-menu.sh &"
                                )
                            },
                        ),
                        widget.Net(
                            foreground="#83c092",
                            format="{down:.0f}{down_suffix} ↓↑ {up:.0f}{up_suffix}",
                            mouse_callbacks={
                                "Button1": lazy.spawn(
                                    "zsh -c ~/.config/qtile/src/rofi-wifi-menu.sh &"
                                )
                            },
                        ),
                    ],
                    close_button_location="right",
                    text_closed=" 󰀂 ",
                    text_open=" 󰢃 ",
                    foreground="#d699b6",
                ),
                # widget.Sep(),
                widget.Sep(),
                widget.TextBox(
                    text="  ",
                    mouse_callbacks={
                        "Button1": lazy.spawn(
                            "zsh -c ~/.config/qtile/src/rofi-power-menu.sh"
                        )
                    },
                ),
                # widget.QuickExit(
                #     default_text="  ",
                #     countdown_format="[{}]",
                # ),
            ],
            38,
            background="#00000090",
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # Set static wallpaper
        wallpaper="/home/ars/Pictures/wallpaper/nord.jpg",
        # set wallpaper mod to 'fill' or 'stretch'
        wallpaper_mode="stretch",
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="translate.google.com"),
        Match(wm_class="gnome-calculator"),
        Match(wm_class="Msgcompose"),
        Match(wm_class="nl.hjdskes.gcolor3"),
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
