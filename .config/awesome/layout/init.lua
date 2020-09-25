local dpi = require('beautiful.xresources').apply_dpi
local capi = { screen = screen }

-- Grab all panels we want to display
--
local WorkspacePanel    = require('layout.workspace-panel')
local ModePanel         = require('layout.mode-panel')
local TasklistPanel     = require('layout.tasklist-panel')
local DateTimePanel     = require('layout.date-time-panel')

capi.screen.connect_signal('request::desktop_decoration', function(s)
    require('gears.debug').print_warning('layout: creating desktop decorations ...')

    s.padding = {
        top = dpi(50),
        left = dpi(15),
        right = dpi(15),
        bottom = dpi(15),
    }

    s.mode_panel = ModePanel(s)
    s.workspace_panel = WorkspacePanel(s)
    s.tasklist_panel = TasklistPanel(s)
    s.datetime_panel = DateTimePanel(s)
end)


return {
    --sidebar = require('layout.sidebar'),
    toppanel = require('layout.toppanel')
}
