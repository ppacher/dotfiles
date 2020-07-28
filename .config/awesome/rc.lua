-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")

require("awful.autofocus")

-- Theme {{{
-- ------------------------------------
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/theme.lua")
print("config: theme loaded")

-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
local naughty = require("naughty")
if _G.awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = _G.awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    _G.awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- Client and keys and layouts configuration {{{
-- ------------------------------------
require('config.tags')
require('config.client')
require('config.layouts')

_G.root.keys(require('config.keys.global'))

print("config: client keys and layout config")
-- }}}

-- Modules {{{
-- ------------------------------------
require("modules.layout-switcher")
require("modules.autostart")
require("modules.exitscreen")
require("modules.backdrop")
require("modules.notifications")
-- }}}

-- Layout {{{
-- ------------------------------------
require("layout.toppanel")

--}}}

-- Widget and layout library
local wibox = require("wibox")

local hotkeys_popup = require("awful.hotkeys_popup")
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local helpers = require("helpers")


-- Listeners
--require("ears")

--[[
-- local bar = require("widgets.statusbar")
-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
browser = "firefox"
filemanager= "thunar"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"
shift = "Shift"
ctrl = "Control"
-- Table of layouts to cover with awful.layout.inc, order matters.


-- }}}

icons = require("icons")
icons.init("sheet")

--]]
-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   --{ "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}
local mymainmenu = awful.menu({ items = {

 { "Terminal Emulator", terminal },
 { "Web Browser", browser },
 { "File Manager", filemanager} ,
 { "Search " , "rofia "} ,
 { "awesome", myawesomemenu }
                                  }
                        })

local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })


-- Keyboard map indicator and switcher

-- {{{ Wibar

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- }}}


-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Enable THICC Title Bars only while Floating
client.connect_signal("property::floating", function(c)
    local b = false;
    if c.first_tag ~= nil then
        b = c.first_tag.layout.name == "floating"
    end
    if c.floating or b then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end
end)

client.connect_signal("manage", function(c)
    print("managing client " .. tostring(c.skip_decoration))
    if c.floating or c.first_tag.layout.name == "floating" then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end

    if c.skip_decoration then
        awful.titlebar.hide(c)
    end
end)

tag.connect_signal("property::layout", function(t)
    local clients = t:clients()
    for k,c in pairs(clients) do
        if c.floating or c.first_tag.layout.name == "floating" then
            awful.titlebar.show(c)
        else
            awful.titlebar.hide(c)
        end
    end
end)
-- }}}


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

  -- Rounded Corners
    if not c.fullscreen and not c.maximized then
        c.shape = helpers.rrect(beautiful.border_radius)
    end
end)

-- Don't add those curves on full clients
local function no_round_corners (c)
    if c.fullscreen or c.maximized then
        c.shape = gears.shape.rectangle
    else
        c.shape = helpers.rrect(beautiful.border_radius)
    end
end

client.connect_signal("property::fullscreen", no_round_corners)
client.connect_signal("property::maximized", no_round_corners)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
          if c.maximized == true then   c.maximized = false end 
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )   
    local borderbuttons = gears.table.join(
	awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end),

        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = beautiful.titlebar_size}) : setup {
        { -- Left
--          awful.titlebar.widget.iconwidget     (c),
--          awful.titlebar.widget.ontopbutton    (c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            --{ -- Title
                --align  = "center",
                --widget = awful.titlebar.widget.titlewidget(c)
            --},
            --buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
--          awful.titlebar.widget.floatingbutton (c),
--          awful.titlebar.widget.maximizedbutton(c),
--          awful.titlebar.widget.stickybutton   (c),
--          awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.minimizebutton (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
_G.client.connect_signal(
    'mouse::enter',
    function(c)
        c:emit_signal('request::activate', 'mouse_enter', {raise = false})
    end
)

-- Change client border when focused/unfocused
_G.client.connect_signal(
    'focus', 
    function(c)
        c.border_color = beautiful.border_focus
    end
)
_G.client.connect_signal(
    'unfocus', 
    function(c)
        c.border_color = beautiful.border_normal
    end
)


_G.root.keys(require('config.keys.global'))
