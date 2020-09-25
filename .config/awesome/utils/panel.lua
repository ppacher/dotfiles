local wibox     = require('wibox')
local beautiful = require('beautiful')
local gears     = require('gears')
local capi      = { screen = screen }
local dpi       = require('beautiful.xresources').apply_dpi

local Panel = function(args)
    args = args or {}
    local scr = args.screen or capi.screen.primary

    local offsety = dpi(7)
    local offsetx = args.offset or 0

    local defaults = {
        ontop = false,
        height = dpi(32),
        width = dpi(180),
        screen = scr,
        x = scr.geometry.x + offsetx,
        y = scr.geometry.y + offsety,
        stretch = false,
        bg = beautiful.xbackground,
        fg = beautiful.xcolor4,
        visible = true,
        struts = {top = dpi(32)}
    }

    local tbl_args = gears.table.crush(defaults, args)

    local panel = wibox(tbl_args)

    return panel
end

return Panel