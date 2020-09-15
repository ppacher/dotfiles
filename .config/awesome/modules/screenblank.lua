local awful  = require("awful")
local modules = require('module-system')

local screenblank = {}

-- Force the displays to be off.
function screenblank.dpms_off()
    awesome.emit_signal("evil::screensaver", true)
end

-- Force the displays to be on.
function screenblank.dpms_on()
    awesome.emit_signal("evil::screensaver", false)
end

function init()
    -- Enables DPMS but disables automatic suspend/standby
    -- timers as we are handling them ourself using 
    -- xidlehook.
    awful.spawn.with_shell("xset +dpms ; xset dpms 0 0 0 ; xset s off")

    awesome.connect_signal("evil::screensaver", function(screen_off)
        if not screen_off and screen_off ~= nil then 
            awful.spawn("xset dpms force on")
        else
            awful.spawn("xset dpms force off")
        end
    end)
end

modules:connect_signal("request::init", function()
    print("initializing screenblank module")
    init()
end)

return screenblank