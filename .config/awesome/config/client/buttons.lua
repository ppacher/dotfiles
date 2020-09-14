local awful = require('awful')
local modkey = require('config.keys.mod').modKey

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button(
            {},
            1,
            function(c)
                _G.client.focus = c
                c:raise()
            end
        ),
        awful.button(
            {modkey},
            1,
            awful.mouse.client.move
        ),
        awful.button(
            {modkey},
            3,
            awful.mouse.client.resize
        ),
        awful.button(
            {modkey},
            4,
            function()
                awful.layout.inc(1)
            end
        ),
        awful.button(
            {modkey},
            5,
            function()
                awful.layout.inc(-1)
            end
        ),
    })
end)
