--            _ _                                
--   _____  _(_) |_ ___  ___ _ __ ___  ___ _ __  
--  / _ \ \/ / | __/ __|/ __| '__/ _ \/ _ \ '_ \ 
-- |  __/>  <| | |_\__ \ (__| | |  __/  __/ | | |
--  \___/_/\_\_|\__|___/\___|_|  \___|\___|_| |_|



local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
-- local naughty = require("naughty")
local helpers = require("helpers")


-- Appearance
local icon_font = "Font Awesome 5 45"
local poweroff_text_icon = ""
local reboot_text_icon = ""
local suspend_text_icon = ""
local exit_text_icon = ""
local lock_text_icon = ""
local exitscreen_bg = beautiful.xbackground .. "99"

local button_bg = beautiful.xcolor0
local button_size = dpi(120)

-- Commands
local poweroff_command = function()
    awful.spawn.with_shell("systemctl poweroff")
end
local reboot_command = function()
    awful.spawn.with_shell("systemctl reboot")
end
local suspend_command = function()
    if lock_screen_show then
        lock_screen_show()
    end
    awful.spawn.with_shell("systemctl suspend")
end
local exit_command = function()
    _G.awesome.quit()
end
local lock_command = function()
    awful.spawn.with_shell("~/.bin/lock")
end


-- Helper function that generates the clickable buttons
local create_button = function(symbol, hover_color, text, command)
    local icon = wibox.widget {
        forced_height = button_size,
        forced_width = button_size,
        align = "center",
        valign = "center",
        font = icon_font,
        text = symbol,
        -- markup = helpers.colorize_text(symbol, color),
        widget = wibox.widget.textbox()
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
        awful.button({ }, 1, command)
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

    return button
end


-- Create the buttons
local poweroff = create_button(poweroff_text_icon, beautiful.xcolor1, "Poweroff", poweroff_command)
local reboot = create_button(reboot_text_icon, beautiful.xcolor2, "Reboot", reboot_command)
local suspend = create_button(suspend_text_icon, beautiful.xcolor3, "Suspend", suspend_command)
local exit = create_button(exit_text_icon, beautiful.xcolor4, "Exit", exit_command)
local lock = create_button(lock_text_icon, beautiful.xcolor5, "Lock", lock_command)

-- Greeter and profile message boxes.
local greeter_message = wibox.widget { 
    markup = "Choose wisely!",
    font = "Inter UltraLight 48",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

_G.screen.connect_signal(
    'request::desktop_decoration',
    function(s)

        s.exit_screen = wibox
        {
            screen = s,
            type = 'splash',
            visible = false,
            ontop = true,
            fg = "#FEFEFE",
            bg = "#000000a0",
            height = s.geometry.height,
            width = s.geometry.width,
            x = s.geometry.x,
            y = s.geometry.y,
        }
        print("[module:exit_screen] created per-screen wibox")

        local function exit_screen_hide()
            _G.awesome.emit_signal('module::exit_screen_hide')
        end

        local exit_screen_grabber = awful.keygrabber {
            auto_start = true,
            stop_event = 'release',
            keypressed_callback = function(self, mod, key, command)
                -- Ignore case
                key = key:lower()

                if key == 's' then
                    suspend_command()
                elseif key == 'e' then
                    exit_command()
                elseif key == 'l' then
                    lock_command()
                elseif key == 'p' then
                    poweroff_command()
                elseif key == 'r' then
                    reboot_command()
                elseif key == 'escape' or key == 'q' or key == 'x' then
                    exit_screen_hide()
                end
            end
        }

        _G.awesome.connect_signal(
            'module::exit_screen_show',
            function()
                print("[module:exit_screen] signal module::exit_screen_show received")
                for s in _G.screen do
                    s.exit_screen.visible = false
                end
                awful.screen.focused().exit_screen.visible = true
                exit_screen_grabber:start()
            end
        )
        _G.awesome.connect_signal(
            'module::exit_screen_hide',
            function()
                print("[module:exit_screen] signal module::exit_screen_hide received")
                exit_screen_grabber:stop()
                for s in _G.screen do
                    s.exit_screen.visible = false
                end
            end
        )

        s.exit_screen : buttons(gears.table.join(
            -- Left click - Hide exit_screen
            awful.button({ }, 1, function ()
                exit_screen_hide()
            end),
            -- Middle click - Hide exit_screen
            awful.button({ }, 2, function ()
                exit_screen_hide()
            end),
            -- Right click - Hide exit_screen
            awful.button({ }, 3, function ()
                exit_screen_hide()
            end)
        ))

        s.exit_screen : setup {
            nil,
             {
                 nil,
                 {
                     greeter_message,
                     {
                         poweroff,
                         reboot,
                         suspend,
                         exit,
                         lock,
                         spacing = dpi(50),
                         layout = wibox.layout.fixed.horizontal
                     },
                     nil,
                     spacing = dpi(40),
                     layout = wibox.layout.fixed.vertical,
                 },
                 nil,
                 expand = "none",
                 layout = wibox.layout.align.horizontal
             },
             nil,
             expand = "none",
             layout = wibox.layout.align.vertical
         }
         
    end
)