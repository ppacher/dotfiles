local awful = require('awful')
local gears = require('gears')

local keys = require('config.keys.mod')
local modkey = keys.modKey
local altkey = keys.altKey
local ctrl = 'Control'

local dpi = require('beautiful').xresources.apply_dpi

local clientKeys = gears.table.join(
    -- toggle fullscreen
    awful.key(
        {modkey},
        'f',
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "Toggle fullscreen", group = 'Client' }
    ),

    -- toggle floating
    awful.key(
        {modkey, ctrl},
        ' ',
        function(c)
            c.fullscreen = false
            c.maximized = false
            c.floating = not c.floating

            -- if the client is now floating place it
            -- in the middle of the screen
            if c.floating then
                awful.placement.centered(c, {
                    honor_workarea = true
                }) 
            end

            c:raise()
        end,
        { description = "Toggle floating", group = 'Client' }
    ),

    -- terminate client
    awful.key(
        {modkey},
        'q',
        function(c)
            c:kill()
        end,
        { description = "Terminate client", group = 'Client' }
    ),

    -- jump to urgent client
    awful.key(
        {modkey},
        'u',
        awful.client.urgent.jumpto,
        { description = "Jump to urgen client", group = 'Client'}
    ),

    -- Jump between last windows
    awful.key(
        {modkey},
        'Tab',
        function()
            awful.client.focus.history.previous()
            if _G.client.focus then
                _G.client.focus:raise()
            end
        end,
        { description = "Go back", group = 'Client'}
    ),

    -- Center currently floating client
    awful.key(
        {modkey, "Shift"},
        "c",
        function(c)
            awful.placement.centered(c, {
                honor_workarea = true
            })
        end,
        { description = 'Center client', group = 'Client'}
    )
)

return clientKeys