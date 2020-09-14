local awful     = require('awful')
local beautiful = require('beautiful')
local apps      = require('config.apps')

local tags = {
    {
        name = '',
        type = 'terminal',
        default_app = apps.terminal,
    },
    {
        name = '',
        type = 'web',
        default_app = apps.browser
    },

    -- tags only for screen one
    {
        name = '',
        type = 'music',
        default_app = 'spotify',
        screen = 1,
    },

    -- tags only for screen two
    {
        name = '',
        type = 'games',
        default_app = 'minecraft-launcher',
        screen = 2
    }
}

_G.screen.connect_signal(
    'request::desktop_decoration',
    function(s)
        for i, tag in pairs(tags) do
            if not tag.screen or tag.screen == s.index then
                awful.tag.add(
                    tag.name or i,
                    {
                        icon = tag.icon,
                        icon_only = tag.icon or false,
                        layout = awful.layout.suit.tile,
                        gap_single_client = false,
                        gap = beautiful.useless_gap,
                        screen = s,
                        default_app = tag.default_app,
                        selected = i == 1
                    }
                )
            end
        end

        local tagCount = #s.tags
        for i = tagCount + 1, 6 do
            awful.tag.add(
                i,
                {
                    layout = awful.layout.suit.tile,
                    gap_single_client = false,
                    gap = beautiful.useless_gap,
                    screen = s,
                }
            )
        end
    end
)

_G.tag.connect_signal(
    'property::layout',
    function(t)
        local currentLayout = awful.tag.getproperty(t, 'layout')
        if currentLayout == awful.layout.suit.max then
            t.gap = 0
        else
            t.gap = beautiful.useless_gap
        end
    end
)
