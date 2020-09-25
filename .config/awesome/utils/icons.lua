local wibox     = require('wibox')
local gcolor    = require('gears.color')
local gtable    = require('gears.table')
local gfs       = require('gears.filesystem')

local icon_utils = {
    feather_path = gfs.get_configuration_dir() .. 'theme/icons/feather/'
}

function icon_utils.get_feather_path(icon)
    return icon_utils.feather_path .. icon .. '.svg'
end

function icon_utils.feather_icon(args)
    local icon = ''
    if type(args) == 'string' then
        icon = args
        args = {}
    else
        icon = args.icon
    end

    icon = icon_utils.get_feather_path(icon)
    if args.recolor then
        icon = gcolor.recolor_image(icon, args.recolor)
    end

    local widget_args = {
        widget = wibox.widget.imagebox,
        image = icon,
        resize = true,
    }

    gtable.crush(widget_args, args)

    local w = require('gears.debug').dump_return(widget_args)
    require('gears.debug').print_warning(w)

    return wibox.widget(widget_args)
end

return icon_utils