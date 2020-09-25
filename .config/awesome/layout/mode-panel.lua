local awful     = require('awful')
local utils     = require('utils')
local wibox     = require('wibox')
local beautiful = require('beautiful')
local dpi       = require('beautiful.xresources').apply_dpi

local LayoutBox = function(s)
    local layout_box = utils.buttons.with_margin(
        awful.widget.layoutbox{
            screen = s,
            buttons = {
                awful.button(
                    {},
                    1,
                    function()
                        awful.layout.inc(1)
                    end
                ),
                awful.button(
                    {},
                    3,
                    function()
                        awful.layout.inc(-1)
                    end
                ),
                awful.button(
                    {},
                    4,
                    function()
                        awful.layout.inc(1)
                    end
                ),
                awful.button(
                    {},
                    5,
                    function()
                        awful.layout.inc(-1)
                    end
                )
            }
        },
        {
            shape = 'rectangle',
            --hover_color = require('beautiful').xcolor0,
            bg = beautiful.xcolor1,
            hover_color = beautiful.xcolor9,
            margins = dpi(5),
        }
    )
    return layout_box
end

local ModePanel = function(s)
    local panel = utils.panel{
        screen = s,
        offset = dpi(13),
        width = dpi(32),
    }

    panel:setup{
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            LayoutBox(s),
        },
        nil,
        nil
    }

    return panel
end

return ModePanel