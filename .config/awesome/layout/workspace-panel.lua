local wibox     = require('wibox')
local TagList   = require('widgets.tag-list')
local utils     = require('utils')
local dpi       = require('beautiful.xresources').apply_dpi

local WorkspacePanel = function(s)
    local panel = utils.panel{
        screen = s,
        offset = dpi(60),
    }

    panel:setup{
        layout = wibox.layout.align.horizontal,
        TagList(s),
    }
end

return WorkspacePanel