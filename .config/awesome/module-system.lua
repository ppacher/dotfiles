local gfs       = require('gears.filesystem')
local gtable    = require('gears.table')
local gdebug    = require('gears.debug')
local gobject   = require('gears.object')

local __private = {
    block_modules = {},
    modules = {}
}

local class = {}
local modulesys = {}

-----
-- readdir_sync reads the a list of files and directories
-- at path. It uses popen and blocks until the executed
-- command returns. Use with care as it WILL block awesomewm's
-- main-loop.
function readdir_sync(path)
    local files, i = {}, 0
    local pfile = io.popen('ls "'..path..'"')
    for filename in pfile:lines() do
        i = i + 1
        files[i] = filename
    end
    pfile:close()
    return files
end

-----
-- load_module loads the module described by path.
-- @tparam table path A table describing the module to load
-- @tparam string path.path The path to the folder containing the module
-- @tparam string path.file The name of the lua file (or folder) inside path.path
-- @tparam string path.require_as The path prefix to use when requiring the module.
function load_module(path)
    local module_name = path.file:gsub('.lua', '')
    local module_path = path.require_as .. '.' .. module_name
    local file_path = path.path .. '/' .. path.file
    gdebug.print_warning('class: loading module ' .. file_path .. ' as ' .. module_path )

    local success, module = pcall(require, module_path)
    if not success then
        gdebug.print_error(string.format("class: failed to load %s (%s): %s", module_path, file_path, gdebug.dump_return(module)))
    end

    -- module just provides side-effects
    if type(module) ~= 'table' then
        return
    end

    -- call .init() if it's defined as a function
    if module.init and type(module.init) == 'function' then
        gdebug.print_warning('class: ' .. module_path .. ' calling init()')
        module.init()
    end

    __private[module.name or module_name] = module
end

function class:start()
    self.load_modules()

    -- Request all modules to initialize
    modulesys:emit_signal('request::init')
end

-----
-- Mark a module as disabled. If a module is disabled
-- it will not be loaded during load_modules(). Not that
-- disable() must be called before and does not have any
-- effect if the module is already loaded.
-- @tparam string name The name of the module to disable
function class.disable(name)
    __private.block_modules[name] = true
end

-----
-- load_modules loads all awesomewm modules placed at
-- the specified directories. If no searchPath is configured
-- all modules from the "modules/" sub-folder in the current
-- configuration directory (the one containing rc.lua) will
-- be loaded.
-- Module name conflicts will be resolved with modules found
-- in later searchPaths overwriting previous ones.
-- @tparam[opt={}] table search_path A list of search paths
function class.load_modules(search_path)
    search_path = search_path or {
        {
            require_as = "modules",
            path = gfs.get_configuration_dir() .. "/modules",
        }
    }

    -- collect all modules from the searchPaths in
    -- order.
    local modules = {}
    for _, path in ipairs(search_path) do
        for _, file in ipairs(readdir_sync(path.path)) do
            if not __private.block_modules[file:gsub('.lua', '')] then
                table.insert(modules, gtable.join(
                    path,
                    {file = file}
                ))
            end
        end
    end

    for _, module_path in ipairs(modules) do
        local m = load_module(module_path)
    end
end

modulesys = gobject{
    class = setmetatable(class, {
        __index = function(mt, key)
            local mod = __private.modules[key]
            if mod then
                return mod
            end

            gdebug.print_warning('class: module ' .. tostring(key) .. ' not loaded')
        end
    }),
}

return modulesys;