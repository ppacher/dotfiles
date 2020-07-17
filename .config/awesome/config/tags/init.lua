local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local apps = require('config.apps')

--local icons = require('theme.icons')

local tags = {
    {
        name = '1',
        type = 'terminal',
        default_app = apps.terminal,
    },
    {
        name = '2',
        type = 'web',
        default_app = apps.browser },

    -- tags only for screen one
    {
        name = '3',
        type = 'music',
        default_app = 'spotify',
        screen = 1,
    },

    -- tags only for screen two
    {
        name = '3',
        type = 'games',
        default_app = 'minecraft-launcher',
        screen = 2
    }
}

_G.tag.create = function(name, screen)
    screen = screen or awful.screen.focused()

    local t = awful.tag.add(
        name,
        {
            icon_only = true,
            layout = awful.layout.suit.spiral.dwindle,
            gap_single_client = false,
            gab = beautiful.useless_gap,
            screen = screen,
            default_app = 'terminal',
            dynamic = true,
        }
    )

    t:view_only()
    --t.icon = icons[t.index]
end

_G.tag.delete_selected = function()
    local t = awful.screen.focused().selected_tag
    if not t then return end
    t:delete()
end

-- dynamic tags have their index as the icon
-- so we need to ensure to update them when
-- they are moved around.
_G.tag.connect_signal(
    'property::index',
    function(tag, index)
        if tag.dynamic then
            --tag.icon = icons[tag.index]
            print("tag " .. tag.name .. " gets icon " .. tag.icon)
        end
    end
)

_G.tag.connect_signal(
    'request::default_layouts',
    function()
        awful.layout.append_default_layouts({
            awful.layout.suit.spiral.dwindle,
            awful.layout.suit.tile,
            awful.layout.suit.max
        })
    end
)

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
