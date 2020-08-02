local awful = require('awful')
local filesystem = require('gears.filesystem')
local config_dir = filesystem.get_configuration_dir()

return {
    terminal = 'kitty',
    browser = 'google-chrome-stable',
    launcher = "~/.config/rofi/launchers/launcher.sh",
    run_on_start = {
        "setxkbmap -layout de",
    },
}
