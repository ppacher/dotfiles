local awful   = require('awful')
local helpers = require('helpers')
local keys    = require('config.keys.mod')
local modkey  = keys.modKey
local ctrl    = 'Control'

local function screen_width(c)
    if not c then
        return awful.screen.focused().geometry.width
    end
    return c.screen.geometry.width
end

local function screen_height(c)
    if not c then
        return awful.screen.focused().geometry.height
    end
    return c.screen.geometry.height
end

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
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
                if c.floating then
                    c.floating = false
                    return
                end

                helpers.float_and_resize(c, screen_width(c) * 0.45, screen_height(c) * 0.5)
            end,
            { description = "Toggle floating", group = 'Client' }
        ),

        -- toggle ontop
        awful.key(
            {modkey},
            't',
            function(c)
                c.ontop = not c.ontop
            end,
            { description = "Toggle ontop", group = 'Client' }
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

        -- Moving windows, do what I mean
        awful.key(
            {modkey, 'Shift'},
            'Down',
            function(c)
                helpers.move_client_dwim(c, 'down')
            end,
            { description = "Move client down", group = 'Client'}
        ),
        awful.key(
            {modkey, 'Shift'},
            'Up',
            function(c)
                helpers.move_client_dwim(c, 'up')
            end,
            { description = "Move client up", group = 'Client'}
        ),
        awful.key(
            {modkey, 'Shift'},
            'Left',
            function(c)
                helpers.move_client_dwim(c, 'left')
            end,
            { description = "Move client left", group = 'Client'}
        ),
        awful.key(
            {modkey, 'Shift'},
            'Right',
            function(c)
                helpers.move_client_dwim(c, 'right')
            end,
            { description = "Move client right", group = 'Client'}
        ),

        -- Resizing windows, do what I mean
        awful.key(
            {modkey, ctrl},
            'Up',
            function(c)
                helpers.resize_dwim(c, 'up')
            end,
            { description = 'Resize client up', group = 'Client'}
        ),    
        awful.key(
            {modkey, ctrl},
            'Down',
            function(c)
                helpers.resize_dwim(c, 'down')
            end,
            { description = 'Resize client down', group = 'Client'}
        ),
        awful.key(
            {modkey, ctrl},
            'Left',
            function(c)
                helpers.resize_dwim(c, 'left')
            end,
            { description = 'Resize client left', group = 'Client'}
        ),
        awful.key(
            {modkey, ctrl},
            'Right',
            function(c)
                helpers.resize_dwim(c, 'right')
            end,
            { description = 'Resize client right', group = 'Client'}
        ),

        -- Center currently floating client
        awful.key(
            {modkey, "Shift"},
            "c",
            function(c)
                awful.placement.centered(c, {
                    honor_workarea = true,
                    honor_padding = true,
                })
                helpers.single_double_tap(
                    nil,
                    function()
                        helpers.float_and_resize(c, screen_width(c) * 0.65, screen_height(c) * 0.8)
                    end
                )
            end,
            { description = 'Center client (double tap to center and grow)', group = 'Client'}
        )
})
end)
