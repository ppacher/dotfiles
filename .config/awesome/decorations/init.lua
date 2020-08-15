local awful     = require("awful")
local gears     = require("gears")
local beautiful = require("beautiful")
local helpers   = require("helpers")

local decorations = {}

-- Show default titlebars for c
-- if c has custom_decorations set that this is a noop.
function decorations.show(c)
    if not c.custom_decorations or not c.custom_decorations[beautiful.titlebar_position] then
        awful.titlebar.show(c, beautiful.titlebar_position)
    end
end

-- Hide default titlebars for c
-- if c has custom_decorations set that this is a noop.
function decorations.hide(c)
    if not c.custom_decorations or not c.custom_decorations[beautiful.titlebar_position] then
        awful.titlebar.hide(c, beautiful.titlebar_position)
    end
end

function decorations.init()
    require("decorations.titlebars")

    -- Client shape
    --
    --  by default all clients have round borders
    --  but we remove those when the client gets fullscreen
    --  or maximized.
    --
    local function update_shape(c)
        local is_max = c.first_tag ~= nil and c.first_tag.layout == awful.layout.suit.max

        if c.fullscreen or c.maximized or is_max then
            c.shape = gears.shape.rectangle
        else
            c.shape = helpers.rrect(beautiful.border_radius)
        end
    end
    client.connect_signal("manage", update_shape)
    client.connect_signal("property::fullscreen", update_shape)
    client.connect_signal("property::maximized", update_shape)
    tag.connect_signal("property::layout", function(t)
        for k, c in pairs(t:clients()) do
            update_shape(c)
        end
    end)
end

return decorations