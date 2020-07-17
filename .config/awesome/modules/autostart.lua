-- Autostart Module
-- Run all applications listed in config/apps.run_on_start only once when awesome starts.

local awful = require('awful')
local apps = require('config.apps')

local function run_once(cmd)
    local search_str = cmd
    local firstspace = cmd:find(' ')
    if firstspace then
        search_str = cmd:sub(0, firstspace - 1)
    end
    print(cmd)
    awful.spawn.with_shell(
        string.format('pgrep -u $USER -x %s > /dev/null || (%s)', search_str, cmd),
        false
    )
end

for _, app in ipairs(apps.run_on_start or {}) do
    run_once(app)
end