local awful     = require('awful')
local wibox     = require('wibox')
local beautiful = require('beautiful')
local helpers   = require('helpers')
local dpi       = require('beautiful.xresources').apply_dpi

local tasklist_buttons = awful.util.table.join(
    awful.button(
        {},
        1,
        function(c)
            if c == _G.client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                _G.client.focus = c
                c:raise()
            end
        end
    ),
    awful.button(
        {},
        2,
        function(c)
            c.kill(c)
        end
    ),
    awful.button(
        {}, 
        4,
        function()
            awful.client.focus.byidx(1)
        end
    ),
    awful.button(
        {},
        5,
        function()
            awful.client.focus.byidx(-1)
        end
    )
)

local task_popup = awful.popup {
    widget = {
        {
            id = 'title',
            font = beautiful.tasklist_font,
            widget = wibox.widget.textbox,
        },
        margins = dpi(10),
        widget = wibox.container.margin
    },
    ontop = true,
    shape = helpers.rrect(dpi(1)),
    visible = false,
}

local TaskList = function(s)
    local ts
    ts = awful.widget.tasklist{
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        widget_template = {
            {
                awful.widget.clienticon,
                margins = dpi(7),
                widget = wibox.container.margin
            },
            id     = 'background_role',
            forced_width = dpi(35),
            widget = wibox.container.background,

            create_callback = function(self, c, index, objects)
                local old_wibox -- we only hide the popup if the mouse left the wibox


                self:connect_signal('mouse::enter', function()
                    task_popup.screen = c.screen

                    local w = mouse.current_wibox
                    old_wibox = w

                    if not w then return end

                    task_popup.client = c
                    task_popup.y = w.y + w.height + dpi(2)
                    task_popup.x = w.x + dpi(35) * (index-1)

                    task_popup.widget:get_children_by_id('title')[1].markup = helpers.colorize_text(c.name, beautiful.xcolor2)
                    task_popup.visible = true
                end)

                -- if the client get's destroyed we don't get a mouse::leave
                -- signal so make sure to hide the popup if that client was
                -- displayed
                c:connect_signal('unmanage', function()
                    if task_popup.client == c then
                        task_popup.visible = false
                    end
                end)

                self:connect_signal('mouse::leave', function()
                    if old_wibox ~= mouse.current_wibox then
                        task_popup.visible = false
                    end
                end)
            end
        },
    }
    return ts
end

return TaskList