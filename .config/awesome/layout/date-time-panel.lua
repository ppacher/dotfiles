local awful     = require('awful')
local wibox     = require('wibox')
local utils     = require('utils')
local beautiful = require('beautiful')
local dpi       = require('beautiful.xresources').apply_dpi

local DateTimePanel = function(s)
    local icon = wibox.widget{
        widget = wibox.container.background,
        bg = beautiful.xcolor2,
        {
            widget = wibox.container.margin,
            utils.icons.feather_icon {
                icon = 'clock',
                recolor = beautiful.xbackground,
            },
            margins = dpi(6),
        }
    }

    local clock = wibox.widget.textclock(
        '<span font="Iosevka Extended bold 12">%H<span color="'.. beautiful.xcolor3..'">%M</span></span>')
    local date = wibox.widget.textclock('<span font="Iosevka Extended 9" color="'..beautiful.xcolor12..'">%d.%m.%Y</span>')

    local month_calendar = awful.widget.calendar_popup.month{
        screen = s,
        start_sunday = false,
        week_numbers = true,
    }


    local text_clock = wibox.widget {
        layout = wibox.layout.align.horizontal,
        {
            clock,
            left = dpi(10),
            right = dpi(10),
            widget = wibox.container.margin,
        },
        {
            {
                date,
                top = dpi(1),
                left = dpi(10),
                widget = wibox.container.margin,
            },
            bg = beautiful.xcolor8 .. '20',
            widget = wibox.container.background,
        },
    }
    local panel = utils.panel{
        width = dpi(180),
        screen = s,
        offset = dpi(255),
    }
    month_calendar:attach(panel, 'cc')

    panel:setup {
        layout = wibox.layout.align.horizontal,
        icon,
        text_clock,
    }

    return panel
end

return DateTimePanel