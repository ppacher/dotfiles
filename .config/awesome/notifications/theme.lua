local gears = require('gears')
local wibox = require('wibox')
local awful = require('awful')
local ruled = require('ruled')
local naughty = require('naughty')
local menubar = require("menubar")
local beautiful = require('beautiful')
local helpers   = require('helpers')
local dpi = beautiful.xresources.apply_dpi

-- Defaults
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(32)
naughty.config.defaults.timeout = 10
naughty.config.defaults.title = 'System Notification'
naughty.config.defaults.margin = dpi(6)
naughty.config.defaults.border_width = 0
naughty.config.defaults.position = 'top_right'
naughty.config.defaults.shape = gears.shape.rectangle

-- Apply theme variables
naughty.config.padding = 8
naughty.config.spacing = 8
naughty.config.icon_dirs = {
	"/usr/share/icons/Tela",
	"/usr/share/icons/Tela-blue-dark",
	"/usr/share/icons/la-capitaine-icon-theme/",
	"/usr/share/icons/Papirus/",
	"/usr/share/icons/gnome/",
	"/usr/share/icons/hicolor/",
	"/usr/share/pixmaps/"
}
naughty.config.icon_formats = {	"png", "svg", "jpg", "gif" }

-- Presets / rules
ruled.notification.connect_signal('request::rules', function()	
	-- Critical notifs
	ruled.notification.append_rule {
		rule 	  = {
            urgency = 'critical',
            app_icon = nil,
            icon_text = nil
        },
		properties = {
            icon_text = "",
		}
	}
	ruled.notification.append_rule {
		rule       = { urgency = 'critical' },
		properties = { 
			never_timeout = true, -- keep the notification around even if it asks for a timeout
			fg = beautiful.xcolor11,
			--bg = beautiful.xcolor9,
		}
	}

    -- Normal notifs
    ruled.notification.append_rule {
        rule       = {
            urgency = 'normal',
            app_icon = nil,
            icon_text = nil
        },
        properties = {
            icon_text = ""
        }
    }
	ruled.notification.append_rule {
		rule       = { urgency = 'normal' },
		properties = {
			implicit_timeout 	= 15,
			fg = beautiful.xcolor4,
		}
	}

    -- Low notifs
    ruled.notification.append_rule {
        rule       = {
            urgency = 'low',
            app_icon = nil,
            icon_text = nil
        },
        properties = {
            icon_text = ""
        }
    }
	ruled.notification.append_rule {
		rule       = { urgency = 'low' },
		properties = { 
			implicit_timeout	= 15,
			fg = beautiful.xcolor2,
		}
	}
end)

-- XDG icon lookup
naughty.connect_signal("request::icon", function(n, context, hints)
    if context ~= "app_icon" then return end

    local path = menubar.utils.lookup_icon(hints.app_icon) or
        menubar.utils.lookup_icon(hints.app_icon:lower())

    if path then
        n.icon = path
    end
end)

naughty.connect_signal("request::action_icon", function(a, context, hints)
    a.icon = menubar.utils.lookup_icon(hints.id)
end)

-- Naughty template
naughty.connect_signal("request::display", function(n)
    local icon_widget = naughty.widget.icon

    print("[notify] " .. (n.app_name or "<no-name>"))
    
	-- if the notification has a icon_text property
	-- we are going to use that instead of the icon.
	if n.icon_text then
		icon_widget = wibox.widget {
			font = n.icon_font or "Font Awesome 5 Free 19",
			align = "center",
			valign = "center",
			widget = wibox.widget.textbox
		}
	end

	-- naughty.actions template
	local actions_template = wibox.widget {
		notification = n,
        base_layout = wibox.widget {
            spacing = dpi(3),
            layout = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id = 'text_role',
                        font = beautiful.notification_font,
                        widget = wibox.widget.textbox
                    },
                    left = dpi(6),
                    right = dpi(6),
                    widget = wibox.container.margin
                },
                widget = wibox.container.place
            },
            bg = beautiful.xcolor8.."70",
            forced_height = dpi(30),
            forced_width = dpi(90),
            widget = wibox.container.background
        },
        style = {
            underline_normal = false,
            underline_selected = true
        },
        widget = naughty.list.actions
    }

	-- Custom notification layout
	naughty.layout.box {
		notification = n,
		screen = awful.screen.focused(),
		shape = helpers.rrect(beautiful.notification_border_radius),
		border_width = beautiful.notification_border_width,
        border_color = beautiful.notification_border_color,
        position = beautiful.notification_position,
		widget_template = {
            {
                {
                    {
                        {
                            markup = helpers.colorize_text(n.icon_text, n.fg),
                            align = "center",
                            valign = "center",
                            widget = icon_widget,
                        },
                        forced_width = dpi(50),
                        bg = n.bg or beautiful.xbackground,
                        widget  = wibox.container.background,
                    },
                    {
                        {
                            {
                                align = "center",
                                visible = title_visible or n.title,
                                font = beautiful.notification_font or 'DejaVu Sans Light 12',
                                markup = "<b>"..n.title.."</b>",
                                widget = wibox.widget.textbox,
                            },
                            {
                                align = "center",
                                widget = naughty.widget.message,
                            },
                            {
                                helpers.vertical_pad(dpi(10)),
                                {
                                    actions_template,
                                    shape = helpers.rrect(dpi(4)),
                                    widget = wibox.container.background,
                                },
                                visible = n.actions and #n.actions > 0,
                                layout  = wibox.layout.fixed.vertical
                            },
                            layout  = wibox.layout.align.vertical,
                        },
                        margins = beautiful.notification_margin,
                        widget  = wibox.container.margin,
                    },
                    layout  = wibox.layout.fixed.horizontal,
                },
                strategy = "max",
                width    = beautiful.notification_max_width or dpi(450),
                height   = beautiful.notification_max_height or dpi(250),
                widget   = wibox.container.constraint,
			},

            -- Anti-aliasing container
            shape = helpers.rrect(beautiful.notification_border_radius),
            bg = beautiful.xcolor0 .. 'a0',
            widget = wibox.container.background
        }
	}

	-- Destroy popups if dont_disturb mode is on
	if _G.dont_disturb then
		naughty.destroy_all_notifications()
	end

end)

