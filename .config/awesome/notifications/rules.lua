local awful = require('awful')
local ruled = require('ruled')
local naughty = require('naughty')
local beautiful = require('beautiful') 

ruled.notification.connect_signal('request::rules', function()	
    ruled.notification.append_rule {
        rule = { app_name = "Spotify" },
        properties = {
            icon_text = "",
            icon_font = beautiful.icon_font .. " 19",
        }
    }
end)