local awful = require('awful')
local ruled = require('ruled')
local naughty = require('naughty')

ruled.notification.connect_signal('request::rules', function()	
    ruled.notification.append_rule {
        rule = { app_name = "Spotify" },
        properties = {
            icon_text = "",
            icon_font = "Font Awesome 5 Brands 19",
        }
    }
end)