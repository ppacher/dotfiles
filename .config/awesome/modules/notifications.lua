local gears = require('gears')
local wibox = require('wibox')
local awful = require('awful')
local ruled = require('ruled')
local naughty = require('naughty')
local menubar = require("menubar")
local beautiful = require('beautiful')
local helpers   = require('helpers')
local dpi = beautiful.xresources.apply_dpi

local clickable_container = require('widget.material.clickable-container')

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
		rule       = { urgency = 'critical' },
		properties = { 
			font        		= beautiful.font_bold,
            fg 					= '#000000',
			margin 				= dpi(16),
			position 			= 'top_right',
			implicit_timeout	= 0
		}
	}

	-- Normal notifs
	ruled.notification.append_rule {
		rule       = { urgency = 'normal' },
		properties = {
			font        		= beautiful.font_bold,
			bg      			= beautiful.transparent, 
			fg 					= "#ffffff", -- beautiful.fg_normal,
			margin 				= dpi(16),
			position 			= 'top_right',
			timeout 			= 5,
			implicit_timeout 	= 5
		}
	}

	-- Low notifs
	ruled.notification.append_rule {
		rule       = { urgency = 'low' },
		properties = { 
			font        		= beautiful.font,
			bg     				= beautiful.transparent,
			fg 					= "#ffffff", -- beautiful.fg_normal,,
			margin 				= dpi(16),
			position 			= 'top_right',
			implicit_timeout	= 5
		}
	}
end)

-- Error handling
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message,
        app_name = 'System Notification',
        icon = beautiful.awesome_icon
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

-- Naughty template
naughty.connect_signal("request::display", function(n)
	local color = n.bg or beautiful.system_cyan_light
	
	if n.urgency == 'critical' then
		color = beautiful.system_black_light
	end
	
	-- naughty.actions template
	local actions_template = wibox.widget {
		notification = n,
		base_layout = wibox.widget {
			spacing        = dpi(5),
			layout         = wibox.layout.flex.horizontal
		},
		widget_template = {
			{
				{
					{
						{
							id     = 'text_role',
							font   = beautiful.font,
							widget = wibox.widget.textbox
						},
						widget = wibox.container.place
					},
					widget = clickable_container
				},
				bg                 = beautiful.groups_bg,
				shape              = gears.shape.rounded_rect,
				forced_height      = dpi(30),
				widget             = wibox.container.background
			},
			margins = dpi(4),
			widget  = wibox.container.margin
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
		screen = awful.screen.preferred(),
		shape = helpers.rrect(dpi(6)),
		widget_template = {
			-- Maximum size constraint
			{
				-- Minimum size constraint
				{
					-- padding
					{
						-- vertical
						{
							naughty.widget.icon,
							{
								{
									nil,
									{
										align = "left",
										markup = "<b>" .. n.title .. "</b>",
										widget = wibox.widget.textbox,
										font = 'Iosevka Extended 12'
									},
									{
										align = "left",
										markup = n.message,
										font = 'Iosevka Extended 12',
										widget = wibox.widget.textbox,
									},
									layout = wibox.layout.align.vertical,
								},
								left = n.icon and dpi(15),
								widget = wibox.container.margin,
							},
							layout = wibox.layout.align.horizontal,
						},
						{
							-- padding if actions exist
							helpers.vertical_pad(dpi(16)),
							{
								nil,
								actions_template,
								expand = "none",
								layout = wibox.layout.align.horizontal,
							},
							visible = n.actions and #n.actions > 0,
							layout = wibox.layout.fixed.vertical,
						},
						layout = wibox.layout.fixed.vertical,
					},
					margins = dpi(14),
					widget = wibox.container.margin,
				},
				strategy = "min",
				width = dpi(250),
				widget = wibox.container.constraint
			},
			strategy = "max",
			width = dpi(500),
			height = dpi(150),
			widget = wibox.container.constraint,
		}
	}

	-- Destroy popups if dont_disturb mode is on
	local focused = awful.screen.focused()
	if _G.dont_disturb then
		naughty.destroy_all_notifications()
	end

end)

