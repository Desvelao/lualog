--[[
#Lualog class file
@author Desvelao^^
]]

-- Module name: lualog
-- Description: This is a simple logger for Lua. Create a simple logger for Lua with
--              some configurations as show date, stylized tags and logger name.
-- Author: Desvelao^^
-- Repository: https://github.com/Desvelao/lualog

local colorizer = require'lualog.colorizer'
local Inspect = require'lualog.inspect'
local util = require'lualog.util'

-- Create a logger instance what you can customize how elements are printed.
-- @classmod Lualog
local Lualog = {}
Lualog.__class_name = 'lualog'
Lualog.__inspect = Inspect.new()

local unpack = unpack or table.unpack
local pack2 = function(...) return {n=select('#', ...), ...} end
local unpack2 = function(t) return unpack(t, 1, t.n) end

--- Create a Lualog instance
-- @tparam[opt={}] table options Options
-- @tparam[opt=false] string|boolean options.datestring Date string for os.date(). If false, date is not logged
-- @string[opt=""] options.tag Logger tag.
-- @tparam[opt={}] {string,...} options.ignore_levels Array of levels ignored.
-- @tparam[opt={}] {} options.styles Table that define styles.
-- @tparam table options.table_inspect Table inspector config.
-- @tparam[opt=false] boolean options.table_inspect.prettyfy Flag to pretty printing tables.
-- @tparam[opt=true] boolean options.table_inspect.allow_tostring Flag to allow use table __tostring metamethod.
-- @tparam[opt=0] boolean options.table_inspect.level_depth Depth level to inspect tables. 0 means no level limit.
-- @tparam[opt={}] {function,...} options.plugins Plugins.
-- @treturn Lualog
function Lualog.new(options)
    options = options or {}
    options.table_inspect = options.table_inspect or {}

    local default = {
            style = '',
            datestring = false, -- '%I:%M:%S'
            tag = '',
            table_inspect = {
                prettyfy = false,
                allow_tostring = true,
                level_depth = 0
            }
        }

    -- Lualog instance initiation
    local log = {
        __options = { -- Options
            ignore_levels = {},
            datestring = (type(datestring) == 'boolean' and datestring == true and '%I:%M:%S') or util.value.not_nil(options.datestring, default.datestring),
            tag = util.value.not_nil(options.tag,default.tag),
            table_inspect = {
                prettyfy = util.value.not_nil(options.table_inspect.prettyfy,default.table_inspect.prettyfy),
                allow_tostring = util.value.not_nil(options.table_inspect.allow_tostring,default.table_inspect.allow_tostring),
                level_depth = util.value.not_nil(options.table_inspect.level_depth,default.table_inspect.level_depth),
            },
        },
        __class_name = 'lualog-instance', -- Class anme
        __plugins = {} -- Plugins
    }
    setmetatable(log,{
        __index = Lualog,
        --- Print elements with plugins applied
        -- @tparam Lualog t
        -- @param ... Elements to print 
        __call = function(t,...) t:print(...) end
    })

    -- Ignore levels
    options.ignore_levels = options.ignore_levels or {}
    for _,level in ipairs(options.ignore_levels) do
        log.__options.ignore_levels[level] = true
    end

    -- Plugins logging
    -- Return element
    log:use(function (el)
        return el
    end)

    -- Add a table inspector to lualog instance
    log.__inspect = Inspect.new{
                prettyfy = log.__options.table_inspect.prettyfy,
                allow_tostring = log.__options.table_inspect.allow_tostring,
                level_depth = log.__options.table_inspect.level_depth
            }

    -- Add table-inspect plugin if options.plugins contains 'table-inspect'
    options.plugins = options.plugins or {}
    if(util.table.is(options.plugins) and util.table.includes(options.plugins,'table-inspect')) then
        log:use(function(el)
            if(not util.table.is(el)) then return end
            return log.__inspect:parse(el)
        end)
        for i,t in pairs(options.plugins) do
            if(t == 'table-inspect') then table.remove(options.plugins,i) end
        end
    end

    -- Add plugins from options.plugins
    if(util.table.is(options.plugins)) then
        util.table.for_each(options.plugins,
            function(plugin, index, t)
                log:use(plugin)
            end
        )
    end

    -- Decorator to create log methods
    log.__log = function(style, tag)
        return function(...)
            if(not log.__options.ignore_levels[tag]) then
                print(log:__apply_plugins({
                    __class_name = 'lualog-log',
                    style = style,
                    tag = tag
                },...))
            end
            return log
        end
    end

    -- Default log methods

    --- Log info
    -- @param ... Elements to print
    -- @function info
    -- @return self
    log.info = log.__log('blue','info') -- Info log

    --- Log warn
    -- @param ... Elements to print
    -- @function warn
    -- @return self
    log.warn = log.__log('yellow','warn')  -- Warn log
    
    --- Log error
    -- @param ... Elements to print
    -- @function error
    -- @return self
    log.error = log.__log('red','error') -- Error log

    -- Custom log methods
    options.styles = options.styles or {}

    util.table.for_each(options.styles,
        function(opt_style, style, t)
            log[style] = log.__log(opt_style or default.style ,style)
        end
    )

    log.__plugin_logtag = create_plugin(function(el)
        if(not util.table.is(el) or not util.is_instance_of(el, 'lualog-log') or not el.style or not el.tag) then return end
        if(not log.__options.ignore_levels[tag]) then
            local prefix = ''
            if(log.__options.datestring) then
                prefix = prefix .. os.date(log.__options.datestring) .. ' '
            end
            if(#log.__options.tag > 0) then
                prefix = prefix .. log.__options.tag .. ' '
            end
            return prefix..colorizer.ustr(el.style,el.tag)
        end
    end)

    return log
end

--- Function as `print` global function but apply your plugins for each element
-- @param ... Element to print
function Lualog:print(...)
    print(self:__apply_plugins(...))
end

--- Add plugin/s to your lualog instance
-- @tparam function ... Plugin/s to add to the queue
-- @return self
function Lualog:use(...)
    local plugins = pack2(...)
    for _,plugin in pairs(plugins) do
        if(self.__class_name ~= 'lualog-instance' or type(plugin) ~= 'function') then return end
        table.insert(self.__plugins, 1, create_plugin(plugin))
    end
    return self
end

--- Return a text colorized with style. It's necesary use print function to see at console/terminal
-- @string style Style to apply to the text
-- @string text Text
-- @treturn string
function Lualog:paint(style,text)
    return colorizer.ustr(style,text)
end

-- Inspect a table with table inspector
-- @tparam table t Table to inspect with inspector
function Lualog:inspect(t)
    print(self.__inspect:parse(t))
end

-- Create a Plugin
function create_plugin(fn)
    return {render = fn, __class_name = 'lualog-plugin'}
end

-- Apply your plugins
function Lualog:__apply_plugins(...)
    local elements = pack2(...)
    local elements_transformed = {}
    for i,element in pairs(elements) do
        local result = self.__plugin_logtag.render(element)
        if(not result) then
            for _,plugin in pairs(self.__plugins) do
                local result =  plugin.render(element)
                if(result ~= nil) then
                    elements_transformed[i] = tostring(result)
                    break 
                end
            end
        else
            elements_transformed[i] = tostring(result)
        end
    end
    return unpack2(elements_transformed)
end

return setmetatable(Lualog,{__call = function (t,...) return t.new(...) end})