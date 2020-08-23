local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local helpers   = require("helpers")
local pad       = helpers.pad
local dpi       = require("beautiful").xresources.apply_dpi

-- Set up icons
--
local icon_theme = "sheet"
local icons = require("icons")
icons.init(icon_theme)

local height = beautiful.sidebar_height or awful.screen.focused().geometry.height
sidebar = wibox {
    visible = true,
    ontop = true,
    type = "dock",
    bg = beautiful.sidebar_bg or beautiful.xbackground .. 'df',
    fg = beautiful.sidebar_fg or beautiful.xforeground,
    opacity = 1,
    height = height,
    width = beautiful.sidebar_width or 300,
    y = beautiful.sidebar_y or 0,
}

sidebar:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        if app_drawer_show then
            app_drawer_show()
        end
        sidebar.visible = false
    end),
    -- Middle click - Hide sidebar
    awful.button({ }, 2, function ()
        sidebar.visible = false
    end)
))

sidebar:connect_signal("mouse::leave", function ()
    sidebar.visible = false
end)

-- Activate sidebar by moving the mouse at the edge of the screen
local sidebar_activator = wibox {
    y = sidebar.y,
    width = 1,
    height = height,
    visible = true,
    ontop = true,
    opacity = 0,
    below = true,
}

sidebar_activator:connect_signal("mouse::enter", function ()
    sidebar.visible = true
end)

local radius = beautiful.border_radius or 0
if beautiful.sidebar_position == "right" then
    awful.placement.right(sidebar_activator)
    awful.placement.right(sidebar)
    sidebar.shape = helpers.prect(radius, true , false , false , true)
else
    awful.placement.left(sidebar_activator)
    awful.placement.left(sidebar)
    sidebar.shape = helpers.prrect(radius, false , true , true , false)
end

--- {{{ Clock
local fancy_time_widget = wibox.widget {
    format = "%H%M",
    widget = wibox.widget.textclock,
    align = "center",
    valign = "center",
    font = "Iosevka Extended 55",
}

fancy_time_widget.markup = fancy_time_widget.text:sub(1,2) .. "<span foreground='" .. beautiful.xcolor12 .."'>" .. fancy_time_widget.text:sub(3,4) .. "</span>"
fancy_time_widget:connect_signal("widget::redraw_needed", function () 
    fancy_time_widget.markup = fancy_time_widget.text:sub(1,2) .. "<span foreground='" .. beautiful.xcolor12 .."'>" .. fancy_time_widget.text:sub(3,4) .. "</span>"
end)

local fancy_time = {
    fancy_time_widget,
    layout = wibox.layout.fixed.vertical,
}
--- }}}


--- {{{ Date

local fancy_date_widget = wibox.widget.textclock('%A %d')
fancy_date_widget.markup = helpers.colorize_text(fancy_date_widget.text, beautiful.xcolor12)
fancy_date_widget:connect_signal("widget::redraw_needed", function () 
    fancy_date_widget.markup = helpers.colorize_text(fancy_date_widget.text, beautiful.xcolor12)
end)

fancy_date_widget.align = "center"
fancy_date_widget.valign = "center"
fancy_date_widget.font = "Iosevka Extended 15"

local fancy_date_decoration = wibox.widget.textbox()
local decoration_string = "──────  ──────"
fancy_date_decoration.markup = helpers.colorize_text(decoration_string, beautiful.xcolor2)
fancy_date_decoration.font = "Iosevka Extended 25"
fancy_date_decoration.align = "center"
fancy_date_decoration.valign = "top"

local fancy_date = {
    fancy_date_widget,
    fancy_date_decoration,
    layout = wibox.layout.fixed.vertical,
}

---}}}

sidebar:setup {
    { ----------- TOP GROUP -----------
        fancy_time,
        top = dpi(25),
        left = dpi(20),
        right = dpi(20),
        bottom = dpi(10),
        widget = wibox.container.margin
    },
    { ----------- MIDDLE GROUP -----------
        fancy_date,
        helpers.vertical_pad(30),
        layout = wibox.layout.fixed.vertical
    },
    layout = wibox.layout.align.vertical,
}

return sidebar
