--[[

Adapted to my needs from the original author:
    github.com/streetturtle/awesome-buttons

]]--
local wibox = require("wibox")
local gears = require("gears")
local gfs   = require("gears.filesystem")
local color = require("utils.color")
local dpi   = require("beautiful.xresources").apply_dpi

local buttons = {
    icon_path = gfs.get_configuration_dir() .. 'theme/icons'
}

local function add_default_button(btn, args)
    local btn_type = args.type or 'basic'
    local color = args.color or '#D8DEE9'
    local shape = args.shape or 'circle'
    local onclick = args.onclick or function () end
    local border_width = args.outline_border_width or dpi(1)

    if btn_type == 'outline' then
        btn:set_shape_border_color(color)
        btn:set_shape_border_width(border_width)
    end

    if btn_type == 'flat' then
        btn:set_bg(color)
    end

    if shape == 'circle' then
        btn:set_shape(gears.shape.circle)
    elseif shape == 'rounded_rect' then
        btn:set_shape(function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 4)
        end)
    elseif type(shape) == 'function' then
        btn:set_shape(shape)
    else
        btn:set_shape(gears.shape.rectangle)
    end

    buttons.add_hover_effect({
        widget = btn,
        type = btn_type,
        hover_color = args.hover_color,
    })

    buttons.add_press_effect{
        widget = btn,
    }

    btn:connect_signal("button::release", onclick)
end

buttons.add_hover_effect = function(args)
    local old_cursor, old_wibox
    local widget = args.widget
    local btn_type = args.type
    local hover_color = args.hover_color or '#00000044'

    widget:connect_signal("mouse::enter", function(c)
        if btn_type ~= 'flat' then
            c:set_bg(hover_color)
        end
        local wb = mouse.current_wibox
        old_cursor, old_wibox = wb.cursor, wb
        wb.cursor = "hand1"
    end)

    widget:connect_signal("mouse::leave", function(c)
        if btn_type ~= 'flat' then
            c:set_bg('#00000000')
        end
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)
end

buttons.add_press_effect = function(args)
    local old_cursor, old_wibox, old_color
    local widget = args.widget

    widget:connect_signal("button::press", function(c)
        local r, g, b, a
        local current = c:get_bg()

        if current.get_rgba then
            _, r, g, b, a = current:get_rgba()
        elseif type(current) == 'string' then
            r, g, b, a = color.hex2rgb(current)
        else
            require('gears.debug').print_warning("failed to get current background color")
            return
        end

        old_color = color.cairo2hex(r, g, b, a)

        local new_color
        if (a ~= 1) then
            a = a + 0.25
            a =  a > 1 and 1 or a
            new_color = color.cairo2hex(r, g, b, a)
        else
            new_color = color.darken(old_color, 25)
        end

        c:set_bg(new_color)

        local wb = mouse.current_wibox
        old_cursor, old_wibox = wb.cursor, wb
        wb.cursor = "cross"
    end)

    widget:connect_signal("button::release", function(c)
        if old_color then
            c:set_bg(old_color)
            old_color = nil
        end

        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)
end

-----
-- Create an new icon button
--
-- @staticfct utils.buttons.with_icon
-- @tparam table args The arguments
-- @tparam[opt="basic"] string args.type The type of button. Can be basic, flat or outline
-- @tparam[opt="#D8DEE9"] string args.color The text color for the button
-- @tparam[opt="help-circle"] string args.icon The name of the icon to display
-- @tparam[opt="circle"] string args.shape The shape identifier of the button. Valid are circle, rounded_rect or a function
-- @tparam[opt=20] number args.size The forced size of the button
-- @tparam[opt=1] number args.outline_border_width The width of the outline border
buttons.with_icon = function(args)
    local icon = args.icon or 'help-circle'
    local size = args.size or dpi(20)
    args.hover_color = args.color or '#D8DEE9'

    if icon:sub(1, 1) ~= '/' then
        if type(buttons.icon_path) == 'function' then
            icon = buttons.icon_path(icon)
        else
            icon = buttons.icon_path .. icon .. '.svg'
        end
    end

    local result = wibox.widget{
        {
            {
                image = icon,
                resize = true,
                forced_height = size,
                forced_width = size,
                widget = wibox.widget.imagebox
            },
            margins = 8,
            widget = wibox.container.margin
        },
        bg = '#00000000',
        widget = wibox.container.background
    }

    add_default_button(result, args)

    return result
end

buttons.with_text = function(args)
    local btn_type = args.type or 'basic'
    local text = args.text
    local color = args.color or '#D8DEE9'
    local text_size = args.text_size or 10

    local result = wibox.widget{
        {
            {
                markup = '<span size="' .. text_size .. '000" foreground="' .. ((btn_type == 'flat') and '#00000000' or color) .. '">' .. text ..'</span>',
                widget = wibox.widget.textbox
            },
            top = 4, bottom = 4, left = 8, right = 8,
            widget = wibox.container.margin
        },
        bg = '#00000000',
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 5)
        end,
        widget = wibox.container.background

    }

    add_default_button(result, args)

    return result
end

buttons.with_icon_and_text = function(args)
    local btn_type = args.type or 'basic'
    local text = args.text
    local icon = args.icon
    local color = args.color or '#D8DEE9'
    local text_size = args.text_size or 10

    if icon:sub(1, 1) ~= '/' then
        if type(buttons.icon_path) == 'function' then
            icon = buttons.icon_path(icon)
        else
            icon = buttons.icon_path .. icon .. '.svg'
        end
    end

    local result = wibox.widget{
        {
            {
                {
                    image = icon,
                    resize = true,
                    forced_height = 20,
                    widget = wibox.widget.imagebox
                },
                margins = 4,
                widget = wibox.container.margin
            },
            {
                {
                    markup = '<span size="' .. text_size .. '000" foreground="' .. ((btn_type == 'flat') and '#00000000' or color) .. '">' .. text ..'</span>',
                    widget = wibox.widget.textbox
                },
                top = 4, bottom = 4, right = 8,
                widget = wibox.container.margin
            },
            layout = wibox.layout.align.horizontal
        },
        bg = '#00000000',
        shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 4) end,
        widget = wibox.container.background
    }

    add_default_button(result, args)

    return result
end

return buttons