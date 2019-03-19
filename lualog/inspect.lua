local Colorizer = require'lualog.colorizer'
local util = require'lualog.util'

local Inspect = {}

Inspect.config = {
    prettyfy = false,
    allow_tostring = true,
    level_depth = 0,
    type_values = {
        number = {style = 'green'},
        string = {style = 'yellow', render = function(value) return '"'..value..'"' end},
        ["function"] = {style = 'blue'},
        table = {style = 'red'},
        boolean = {style = 'magenta'},
        ["nil"] = {style = 'cyan'}
    }
}

function Inspect.new(options)
    local config = options or {}
    local inspect = {config = setmetatable(options or {}, {__index = Inspect.config})}
    return setmetatable(inspect, {__index = Inspect})
end

function Inspect:parse(o, options)
    options = options or {}
    local config = {
        prettyfy = options.prettyfy or self.config.prettyfy,
        allow_tostring = options.allow_tostring or self.config.allow_tostring,
        level_depth = options.level_depth or self.config.level_depth,
        _level = options._level or 1
    }
    local if_prettyfy = util.deco.if_condition(config.prettyfy)
    local char_pretiffy = ' '
    local result = '{' .. if_prettyfy('\n','')
    local length = 0
    for k,v in pairs(o) do
        length = length + 1
        local mt = getmetatable(v) or nil
        if(config.allow_tostring and mt and mt.__tostring)then return mt.__tostring() end
        local val, style_elem, render_elem = v, '', function(value) return value end
        result = result .. if_prettyfy(char_pretiffy:rep(config._level),'') .. k .. ' = '
        if(type(v) == 'table' and (config.level_depth  == 0 or config.level_depth > config._level)) then
            val = self:parse(v, {level_depth = config.level_depth, _level = config._level + 1, prettyfy = config.prettyfy, allow_tostring = config.allow_tostring})
        else
            val = v
            style_elem = (self.config.type_values[type(v)] and self.config.type_values[type(v)].style) or ''
            render_elem = (self.config.type_values[type(v)] and self.config.type_values[type(v)].render) or render_elem
        end
        result = result .. Colorizer.ustr(style_elem,tostring(render_elem(val)))..', ' .. if_prettyfy('\n','')
    end
    result = result:sub(0,if_prettyfy(-4,-3)) .. (length > 0 and if_prettyfy('\n' .. char_pretiffy:rep(config._level-1),'') or '') .. (length > 0 and '}' or '{}')
    local parsed = { text = result}

    return setmetatable(parsed,{
        __index = {
            print = function(t) print(t.text) end
        },
        __tostring = function(t) return t.text end}
    )
end

return Inspect