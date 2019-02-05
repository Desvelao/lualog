-- local pkgpath = string.gsub(...,'%.','/')
-- print('init luachalk',...)
-- package.path = package.path .. ';' .. pkgpath ..'/?.lua;'
local colors = require'luachalk.colors'
local Chalk = {}
Chalk.__index = Chalk
Chalk.__call = function(cls,...)
    return  cls.new(...)
end

local ustring = function(value)
    return '\u{001b}['..value..'m'
end

function Chalk.new(options)
    options = options or {}
    local c = {}
    c.level = options.level or 1
    c.enabled = options.enabled or c.level > 0
    for color,value in pairs(colors) do
        if(color ~= 'reset') then
            c[color] = function (s)
                io.write(ustring(value)..s..ustring(colors.reset))
                return c
            end
        
        end
    end
    c.ustr = function(style, str)
        local styles = {}
        for s in string.gmatch(style, "[^%.]+") do
            table.insert(styles, s)
        end
        local style = ''
        for _, sty in ipairs(styles) do
            style = ustring(colors[sty])
        end
        return style..str..ustring(colors.reset)
    end
    c.codes = colors
    setmetatable(c,Chalk)
    return c
end

return Chalk.new()
-- return Chalk