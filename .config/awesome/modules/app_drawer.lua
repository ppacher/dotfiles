local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi
local helpers   = require("helpers")
local icons     = require("icons")

local keybindings = {}

-- Create a icon button with "hover" and "click" effects.
-- If cmd is given it is executed when clicked. 
local function create_button(symbol, color, hover_color, cmd, key)
    local button_bg = beautiful.xcolor0
    local button_size = dpi(120)

    local widget = wibox.widget.textbox()

    if icons[symbol] then
        widget = wibox.widget.imagebox()
    end

    local icon = wibox.widget {
        forced_height = button_size,
        forced_width = button_size,
        align = "center",
        valign = "center",
        font = beautiful.icon_font .. " 50",
        text = symbol,
        image = icons[symbol],
        widget = widget,
    }

    local button = wibox.widget {
        {
            nil,
            icon,
            expand = "none",
            layout = wibox.layout.align.horizontal
        },
        forced_height = button_size,
        forced_width = button_size,
        border_width = dpi(8),
        border_color = button_bg,
        shape = helpers.rrect(dpi(20)),
        bg = button_bg,
        widget = wibox.container.background
    }

    -- Bind left click to run the command
    button:buttons(gears.table.join(
        awful.button({ }, 1, cmd)
    ))

    -- Change color on hover
    button:connect_signal(
        "mouse::enter",
        function ()
            icon.markup = helpers.colorize_text(icon.text, hover_color)
            button.border_color = hover_color
        end
    )
    button:connect_signal(
        "mouse::leave",
        function ()
            icon.markup = helpers.colorize_text(icon.text, beautiful.xforeground)
            button.border_color = button_bg
        end
    )

    -- Use helper function to change the cursor on hover
    helpers.add_hover_cursor(button, "hand1")

    if key then
        keybindings[key] = cmd
    end

    return button
end

local app_drawer = wibox{
    visible = false,
    ontop = true,
    type = "dock",
    fg = '#FEFEFE', -- beautiful.xforeground,
    bg = '#000000a0', -- beautiful.xbackground .. "30"
} 

awful.placement.maximize(app_drawer)

_G.screen.connect_signal(
    'request::desktop_decoration',
    function(s)
        if s == screen.primary then
            s.app_drawer = app_drawer
        else
            s.app_drawer = helpers.screen_mask(s, '#000000a0')
        end
    end
)

local function set_visible(visible)
    for s in screen do
        if not s.app_drawer then
            return
        end
        s.app_drawer.visible = visible
    end
end


local app_drawer_grabber
function app_drawer_hide()
    awful.keygrabber.stop(app_drawer_grabber)
    set_visible(false)
end

function app_drawer_show()
    app_drawer_grabber = awful.keygrabber.run(function(_, key, event)
        local invalid_key = false

        if event == "release" then return end
        if keybindings[key] then
            keybindings[key]()
        else
            invalid_key = true
        end

        if not invalid_key or key == 'Escape' then
            app_drawer_hide()
        end
    end)

    set_visible(true)
end

app_drawer:buttons(gears.table.join(
    awful.button({ }, 1, function()
        app_drawer_hide()
    end),
    awful.button({ }, 2, function()
        app_drawer_hide()
    end),
    awful.button({ }, 3, function()
        app_drawer_hide()
    end)
))

local function create_stripe(widgets)
    local buttons = wibox.widget {
        spacing = dpi(50),
        layout = wibox.layout.fixed.horizontal
    }

    for _, widget in ipairs(widgets) do
        buttons:add(widget)
    end

    local stripe = wibox.widget {
        {
            nil,
            {
                nil,
                buttons,
                expand = "none",
                layout = wibox.layout.align.horizontal
            },
            expand = "none",
            layout = wibox.layout.align.vertical
        },
        widget = wibox.container.background
    }

    return stripe
end

-- Date and time widgets
--
local time = wibox.widget {
    format = "%H%M",
    widget = wibox.widget.textclock,
    font = "Marigolds 60",
}

time.markup = time.text:sub(1,2) .. helpers.colorize_text(time.text:sub(3,4), beautiful.xcolor12)
time:connect_signal("widget::redraw_needed", function () 
    time.markup = time.text:sub(1,2) .. helpers.colorize_text(time.text:sub(3,4), beautiful.xcolor12) 
end)

local date = wibox.widget {
    format = '%A %d',
    widget = wibox.widget.textclock,
    font = "Marigolds 60",
}

date.markup = helpers.colorize_text(date.text, beautiful.xcolor12)
date:connect_signal("widget::redraw_needed", function () 
    date.markup = helpers.colorize_text(date.text, beautiful.xcolor12)
end)


--- create the buttons
--
local apps = require("config.apps")

local function spawn(what)
    return function()
        awful.spawn.with_shell(what)
    end
end

terminal = create_button("", beautiful.xcolor3, beautiful.xcolor11, spawn(apps.terminal), "t")
browser = create_button("netflix", beautiful.xcolor5, beautiful.xcolor13, spawn(apps.browser), "b")

app_drawer:setup {
    -- Background
    {
        create_stripe({}),
        create_stripe({
            {
                {
                    markup = "What's up?",
                    font = "Marigolds 88",
                    align = "center",
                    valign = "center",
                    widget = wibox.widget.textbox
                },
                {
                    markup = helpers.colorize_text("────────  ────────", beautiful.xcolor2),
                    font = "Iosevka Extended 45",
                    align = "center",
                    valign = "top",
                    widget = wibox.widget.textbox()
                },
                {
                    nil,
                    {
    
                        {
                            text = "it's ",
                            font = "Marigolds 40",
                            widget = wibox.widget.textbox,
                        },
                        time,
                        {
                            text = "on",
                            font = "Marigolds 40",
                            widget = wibox.widget.textbox,
                        },
                        date,
                        spacing = dpi(30),
                        layout = wibox.layout.fixed.horizontal,
                    },
                    expand = "none",
                    layout = wibox.layout.align.horizontal,
                },
                layout = wibox.layout.align.vertical,
            }
        }),
        create_stripe({terminal, browser}),
        create_stripe({}),
        layout = wibox.layout.flex.vertical
    },
    --bg = beautiful.xbackground .. "c0",
    widget = wibox.container.background
}