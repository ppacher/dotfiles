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

-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
local naughty = require("naughty")
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
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

root.keys(require('config.keys.global'))

local icons = require("icons")
icons.init("sheet")

-- Modules {{{
-- ------------------------------------
require("modules.layout-switcher")
require("modules.autostart")
require("modules.exitscreen")
require("modules.backdrop")
require("modules.app_drawer")

local notifs = require("notifications")
notifs.init()

-- Layout {{{
-- ------------------------------------
require("layout.toppanel")
require("layout.sidebar")
--}}}

-- Decorations
--
local decorations = require("decorations")
decorations.init()

-- Widget and layout library
local wibox = require("wibox")

local hotkeys_popup = require("awful.hotkeys_popup")
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local mymainmenu = awful.menu {
    items = {
        { "Terminal Emulator", terminal },
        { "Web Browser", browser },
        { "File Manager", filemanager} ,
        { "Search " , "rofia "} ,
        { "awesome", myawesomemenu },
    },
}

-- Keyboard map indicator and switcher

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
--
local update_decorations = function(c)
    if not c.skip_decoration and (c.floating or awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
        decorations.show(c)
    else
        decorations.hide(c)
    end
end

client.connect_signal("manage", update_decorations)
client.connect_signal("property::floating", update_decorations)
tag.connect_signal("property::layout", function(t)
    for k, c in pairs(t:clients()) do
        update_decorations(c)
    end
end)
-- }}}


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    --
    -- if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)


-- Enable sloppy focus, so that focus follows mouse.
_G.client.connect_signal(
    'mouse::enter',
    function(c)
        c:emit_signal('request::activate', 'mouse_enter', {raise = c.floating})
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
