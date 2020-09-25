local awful     = require('awful')
local beautiful = require('beautiful')
local wibox     = require('wibox')
local utils     = require('utils')
local dpi       = require('beautiful.xresources').apply_dpi
local TaskList  = require('widgets.tasklist')

local TasklistPanel = function(s)
    local width = dpi(512)
    local panel = utils.panel{
        screen = s,
        width = width,
        offset = (s.geometry.width - width) / 2,
    }

    local addbtn = utils.buttons.with_icon{
        icon = "plus",
        hover_color = beautiful.xcolor0,
        bg = beautiful.xcolor8,
        shape = 'rect',
        onclick = function()
            local selected_tag = s.selected_tag
            if selected_tag ~= nil and selected_tag.default_app then
                awful.spawn.with_shell(selected_tag.default_app)
            end
        end
    }

    panel:setup {
        layout = wibox.layout.align.horizontal,
        addbtn,
        {
            TaskList(s),
            layout = wibox.layout.fixed.horizontal,
        },
        nil
    }
    
    return panel
end

return TasklistPanel