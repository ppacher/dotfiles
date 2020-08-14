local awful = require('awful')
local gears = require('gears')
local awesome, client, screen = _G.awesome, _G.client, _G.screen

local hotkeys_popup = require('awful.hotkeys_popup').widget

local modkey = require('config.keys.mod').modKey
local altkey = require('config.keys.mod').altKey
local apps = require('config.apps')

-- Global key bindings
local globalKeys = gears.table.join(
    -- Most important, Mod4 + Enter => launch kitty
    --
    awful.key(
        {modkey},
        'Return',
        function()
            awful.spawn.with_shell(apps.terminal)
        end
    ),

    -- Default tag apps
    --
    awful.key(
        {modkey, 'Shift'},
        'Return',
        function()
            local selected_tag = awful.screen.focused().selected_tag
            if selected_tag ~= nil and selected_tag.default_app then
                awful.spawn.with_shell(selected_tag.default_app)
            end
        end
    ),
    
    -- Awesome Control Keys
    --
    awful.key(
        {modkey},
        'F1',
        hotkeys_popup.show_help,
        {description = 'show help', group = 'awesome'}
    ),
    awful.key(
        {modkey, 'Control'},
        'r',
        awesome.restart,
        {description = 'restart awesome', group = 'awesome'}
    ),
    awful.key(
        {modkey, 'Control'},
        'q',
        awesome.quit,
        {description = 'quit awesome', group = 'awesome'}
    ),

    -- Layout Master and Column Control
    --
    awful.key(
        {altkey, 'Shift'},
        'l',
        function()
            awful.tag.incmwfact(0.05)
        end,
        {description = 'increase master width factor', group = 'layout'}
    ),
    awful.key(
        {altkey, 'Shift'},
        'h',
        function()
            awful.tag.incmwfact(-0.05)
        end,
        {description = 'decrease master width factor', group = 'layout'}
    ),
    awful.key(
        {modkey, 'Shift'},
        'h',
        function()
            awful.tag.incnmaster(1, nil, true)
        end,
        {description = 'increase the number of master clients', group = 'layout'}
    ),
    awful.key(
        {modkey, 'Shift'},
        'l',
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {description = 'decrease the number of master clients', group = 'layout'}
    ),
    awful.key(
        {modkey, 'Control'},
        'h',
        function()
            awful.tag.incncol(1, nil, true)
        end,
        {description = 'increase the number of columns', group = 'layout'}
    ),
    awful.key(
        {modkey, 'Control'},
        'l',
        function()
            awful.tag.incncol(-1, nil, true)
        end,
        {description = 'decrease the number of columns', group = 'layout'}
    ),

    -- Tag Switching
    --
    awful.key(
        {modkey},
        'd',
        function()
            awful.tag.viewprev()
        end,
        {description = 'view previous tag', group = 'tag'}
    ),
    awful.key(
        {modkey},
        'a',
        function()
            awful.tag.viewnext()
        end,
        {description = 'view next tag', group = 'tag'}
    ),
    awful.key(
        {modkey},
        'Escape',
        awful.tag.history.restore,
        {description = 'Toggle last tag', group = 'tag'}
    ),
    awful.key({ modkey, "Control" },
        "d",
        function ()
            -- tag_view_nonempty(-1)
            local focused = awful.screen.focused()
            for i = 1, #focused.tags do
                awful.tag.viewidx(-1, focused)
                if #focused.clients > 0 then
                    return
                end
            end
        end,
        {description = "view previous non-empty tag", group = "tag"}
    ),
    awful.key({ modkey, "Control" },
        "a",
        function ()
            -- tag_view_nonempty(1)
            local focused =  awful.screen.focused()
            for i = 1, #focused.tags do
                awful.tag.viewidx(1, focused)
                if #focused.clients > 0 then
                    return
                end
            end
        end,
        {description = "view next non-empty tag", group = "tag"}
    ),

    -- Application Launcher
    --
    awful.key(
        {modkey}, 
        'e',
        function()
            awful.spawn.with_shell(apps.launcher)
        end,
        {description = "open application drawer", group = 'launcher'}
    ),

    -- Utilities
    --
    awful.key({
        { modkey },
        'Print',
        function()
            print("shoot")
            awful.spawn.with_shell(apps.shoot_sel)
        end,
        {description = 'take a screenshot', group = 'utils'}
    }),
    awful.key({
        {'Shift'},
        'Print',
        function()
            awful.spawn.with_shell(apps.shoot)
        end,
        {description = 'take a screenshot', group = 'utils'}
    }),

    -- Exit Screen
    awful.key(
        {},
        'XF86HomePage',
        function()
            _G.awesome.emit_signal('module::exit_screen_show')
        end,
        {description = "show exit screen", group = "launcher"}
    )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = 'view tag #', group = 'tag'}
        descr_toggle = {description = 'toggle tag #', group = 'tag'}
        descr_move = {description = 'move focused client to tag #', group = 'tag'}
        descr_toggle_focus = {description = 'toggle focused client on tag #', group = 'tag'}
    end
    globalKeys =
        awful.util.table.join(
        globalKeys,
        -- View tag only.
        awful.key(
            {modkey},
            '#' .. i + 9,
            function()
                local focused = awful.screen.focused()
                local tag = focused.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            descr_view
        ),
        -- Toggle tag display.
        awful.key(
            {modkey, 'Control'},
            '#' .. i + 9,
            function()
                local focused = awful.screen.focused()
                local tag = focused.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            descr_toggle
        ),
        -- Move client to tag.
        awful.key(
            {modkey, 'Shift'},
            '#' .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            descr_move
        ),
        -- Toggle tag on focused client.
        awful.key(
            {modkey, 'Control', 'Shift'},
            '#' .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            descr_toggle_focus
        )
    )
end

return globalKeys