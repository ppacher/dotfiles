local awful = require('awful')
local gears = require('gears')
local ruled = require('ruled')
local beautiful = require('beautiful')

local client_keys = require('config.client.keys')
local client_buttons = require('config.client.buttons')

ruled.client.connect_signal('request::rules', function()
    ruled.client.append_rule {
        id              = "global",
        rule            = { },
        properties      = {
            focus                   = awful.client.focus.filter,
            border_width            = beautiful.border_width,
            border_color            = beautiful.border_normal,
            raise                   = true,
            floating                = false,
            maximized               = false,
            above                   = false,
            below                   = false,
            ontop                   = false,
            sticky                  = false,
            maximized_horizontal    = false,
            maximized_vertical      = false,
            rounded_corners         = true,
            size_hints_honor        = true,
            keys                    = client_keys,
            buttons                 = client_buttons,
            screen                  = awful.screen.preferred,
            placement               = awful.placement.no_overlap + awful.placement.no_offscreen,
        }
    }

    ruled.client.append_rule {
      id = "backdrop",
      rule_any = {
        type = {"dialog"},
        instance = {"pinentry"},
        class = { "Pavucontrol" }
      },
      properties = {
        placement = awful.placement.centered,
        ontop = true,
        floating = true,
        drawBackdrop = true,
        shape = function()
          return function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 8)
          end
        end,
        skip_decoration = true
      }
    }

    ruled.client.append_rule {
      id = "floating",
      rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      },
      properties = {
        floating = true,
      }
    }

    ruled.client.append_rule {
      id = "java",
      rule = {
        name = "Emulator"
      },
      properties = {
        floating = true,
        focus = true,
        focusable = true,
        placement = awful.placement.restore,
      }
    }

    ruled.client.append_rule {
      id = "java",
      rule = {
        class = "jetbrains-studio"
      },
      properties = {
        floating = true,
        focus = true,
        focusable = true,
        placement = awful.placement.restore,
      }
    }
end)
