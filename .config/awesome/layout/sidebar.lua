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

-- Sidebar attributes
sidebar_hide_on_mouse_leave = true
sidebar_show_on_mouse_screen_edge = true
sidebar = wibox ({visible = true , ontop = false , type = "dock" })
sidebar.bg = beautiful.sidebar_bg or beautiful.xbackground .. 'df'
sidebar.fg = beautiful.sidebar_fg or beautiful.xforeground
sidebar.opacity = 1
sidebar.height = beautiful.sidebar_height or awful.screen.focused().geometry.height
sidebar.width = beautiful.sidebar_width or 300
sidebar.y = beautiful.sidebar_y or 0
local radius = beautiful.border_radius or 0

-- Round Corners based on placement
if beautiful.sidebar_position == "right" then
    awful.placement.right(sidebar)
    sidebar.shape = helpers.prect(radius, true , false , false , true)
else
    awful.placement.left(sidebar)
    sidebar.shape = helpers.prrect(radius, false , true , true , false)
end

sidebar:buttons(gears.table.join(
    -- Middle click - Hide sidebar
    awful.button({ }, 2, function ()
        sidebar.visible = false
    end)
    -- Right click - Hide sidebar
    -- awful.button({ }, 3, function ()
    --     sidebar.visible = false
    --     -- mymainmenu:show()
    -- end)
))

sidebar:connect_signal("mouse::leave", function ()
    sidebar.visible = false
end)
-- Activate sidebar by moving the mouse at the edge of the screen
local sidebar_activator = wibox({y = sidebar.y, width = 1, visible = true, ontop = false, opacity = 0, below = true})
sidebar_activator.height = sidebar.height

sidebar_activator:connect_signal("mouse::enter", function ()
    sidebar.visible = true
end)

if beautiful.sidebar_position == "right" then
    awful.placement.right(sidebar_activator)
else
    awful.placement.left(sidebar_activator)
end

sidebar_activator:buttons(
    gears.table.join(
        awful.button({ }, 4, function ()
            awful.tag.viewprev()
        end),
        awful.button({ }, 5, function ()
            awful.tag.viewnext()
        end)
))


--- {{{ Clock

local fancy_time_widget = wibox.widget.textclock("%H%M")
fancy_time_widget.markup = fancy_time_widget.text:sub(1,2) .. "<span foreground='" .. beautiful.xcolor12 .."'>" .. fancy_time_widget.text:sub(3,4) .. "</span>"
fancy_time_widget:connect_signal("widget::redraw_needed", function () 
    fancy_time_widget.markup = fancy_time_widget.text:sub(1,2) .. "<span foreground='" .. beautiful.xcolor12 .."'>" .. fancy_time_widget.text:sub(3,4) .. "</span>"
end)
fancy_time_widget.align = "center"
fancy_time_widget.valign = "center"
fancy_time_widget.font = "Iosevka Extended 55"


local fancy_time = {
    fancy_time_widget,
    layout = wibox.layout.fixed.vertical,
}

--- }}}


--- {{{ Date

local fancy_date_widget = wibox.widget.textclock('%A %d')
fancy_date_widget.markup = "<span foreground='" .. beautiful.xcolor12 .."'>" .. fancy_date_widget.text .. "</span>"
fancy_date_widget:connect_signal("widget::redraw_needed", function () 
    fancy_date_widget.markup = "<span foreground='" .. beautiful.xcolor12 .."'>" .. fancy_date_widget.text .. "</span>"
end)
fancy_date_widget.align = "center"
fancy_date_widget.valign = "center"
fancy_date_widget.font = "Iosevka Extended 15"
local fancy_date_decoration = wibox.widget.textbox()
-- local decoration_string = "------------------------"
local decoration_string = "──────  ──────"
fancy_date_decoration.markup = "<span foreground='" .. beautiful.xcolor2 .."'>"..decoration_string.."</span>"
fancy_date_decoration.font = "Iosevka Extended 20"
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
