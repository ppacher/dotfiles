local awful = require("awful")

local screenblank = {}

-- Force the displays to be off.
function screenblank.dpms_off()
    awesome.emit_signal("evil::dpms-off")
end

-- Force the displays to be on.
function screenblank.dpms_on()
    awesome.emit_signal("evil::dpms-on")
end

function screenblank.init()
    -- Enables DPMS but disables automatic suspend/standby
    -- timers as we are handling them ourself using 
    -- xidlehook.
    awful.spawn.with_shell("xset +dpms ; xset dpms 0 0 0 ; xset s off")

    awesome.connect_signal("evil::dpms-on", function()
        awful.spawn("xset dpms force on")
    end)

    awesome.connect_signal("evil::dpms-off", function()
        awful.spawn("xset dpms force off")
    end)

    awesome.connect_signal("evil::xidle", function()
    end)

    awesome.connect_signal("evil::no-xidle", function()
    end)
end

return screenblank