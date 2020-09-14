local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local icons = require("icons")
local modkey = require("config.keys.mod").modKey

local systray_margin = (beautiful.wibar_height - beautiful.systray_icon_size) / 2

--- {{{ Systray Widget

local systray = wibox.widget.systray()
systray:set_base_size(beautiful.systray_icon_size)

local systray_container = {
    systray,
    top = systray_margin,
    bottom = systray_margin,
    widget = wibox.container.margin
}

--- }}}

--- {{{ Taglist Widget

local taglist_buttons = gears.table.join(awful.button({}, 1, function(t)
    t:view_only()
end), awful.button({modkey}, 1, function(t)
    if _G.client.focus then
        _G.client.focus:move_to_tag(t)
    end
end), awful.button({}, 3, awful.tag.viewtoggle), awful.button({modkey}, 3, function(t)
    if _G.client.focus then
        _G.client.focus:toggle_tag(t)
    end
end), awful.button({}, 4, function(t)
    awful.tag.viewnext(t.screen)
end), awful.button({}, 5, function(t)
    awful.tag.viewprev(t.screen)
end))

--- }}}

--- {{{ Tasklist Widget

local tasklist_buttons = gears.table.join(awful.button({}, 1, function(c)
    if c == _G.client.focus then
        c.minimized = true
    else
        c:emit_signal("request::activate", "tasklist", {
            raise = true
        })
    end
end), awful.button({}, 3, function()
    awful.menu.client_list({
        theme = {
            width = 250
        }
    })
end), awful.button({}, 4, function()
    awful.client.focus.byidx(1)
end), awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
end))

-- Hide the toppanel as long as at least one client
-- is fullscreen
client.connect_signal("property::fullscreen", function(c)
    local has_fullscreen = false
    if not c.screen then
        return
    end

    for _, cli in ipairs(c.screen.clients) do
        has_fullscreen = cli.fullscreen or has_fullscreen
    end

    c.screen.mywibox.visible = not has_fullscreen
end)
--- }}}

awful.screen.connect_for_each_screen(function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        ontop = true
    })

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        style = {
            shape = gears.shape.rectangle
        },
        layout = {
            spacing = 0,
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox
                    },
                    layout = wibox.layout.fixed.horizontal
                },
                left = 11,
                right = 11,
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background
        },
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Add widgets to the wibox
    s.mywibox:setup{
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = beautiful.wibar_spacing,
            s.mytaglist,
            s.mypromptbox
        },
        s.mytasklist, -- Middle widget
        {
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                spacing = beautiful.wibar_spacing,
                systray_container
            },
            left = beautiful.wibar_margin,
            right = beautiful.wibar_margin,
            widget = wibox.container.margin
        }
    }
end)
