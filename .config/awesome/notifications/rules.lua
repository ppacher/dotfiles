local ruled     = require('ruled')
local naughty   = require('naughty')
local cst       = require("naughty.constants");
local beautiful = require('beautiful')

naughty.connect_signal('destroyed', function(n, reason)
    if not n.clients then return end
    if reason == cst.notification_closed_reason.dismissed_by_user then
        for _, cli in ipairs(n.clients) do
            cli.urgent = true
            cli:emit_signal("request::activate", {raise=true})
        end
    end
end)

ruled.notification.connect_signal('request::rules', function()
    ruled.notification.append_rule {
        rule = { app_name = "Spotify" },
        properties = {
            icon_text = "",
            icon_font = beautiful.icon_font .. " 19",
        }
    }
end)