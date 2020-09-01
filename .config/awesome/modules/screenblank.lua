local awful = require("awful")

local screenblank = {}

-- Force the displays to be off.
function screenblank.dpms_off()
    awesome.emit_signal("evil::screensaver", true)
end

-- Force the displays to be on.
function screenblank.dpms_on()
    awesome.emit_signal("evil::screensaver", false)
end

local idle_counter = 0

function screenblank.init()
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

    awesome.connect_signal("evil::xidle", function()
        idle_counter = idle_counter + 10

        if idle_counter % 60 == 0 then
            awesome.emit_signal("evil::idle::minute", idle_counter)
        end

        if idle_counter % 3600 == 0 then
            awesome.emit_signal("evil::idle::hour", idle_counter)
        end
    end)

    awesome.connect_signal("evil::no-xidle", function()
        idle_counter = 0
    end)
end

return screenblank