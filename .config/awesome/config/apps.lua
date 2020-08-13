local awful = require('awful')
local filesystem = require('gears.filesystem')
local config_dir = filesystem.get_configuration_dir()

return {
    terminal = 'kitty',
    browser = 'google-chrome-stable',
    launcher = "~/.config/rofi/launchers/launcher.sh",
    shoot = '~/.bin/shoot',
    shoot_sel = '~/.bin/shoot sel',
    run_on_start = {
        "setxkbmap -layout de",
        "/usr/bin/feh --bg-fill $HOME/Pictures/wallpapers/wall.png",
        "systemctl --user restart picom", -- the current git version sometimes doesn't like an awesome restart
    },
}
