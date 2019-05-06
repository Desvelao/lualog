--[[
#Utils
]]
local util = {
    table = {},
    deco = {},
    value = {}
}

--- Returns whether a table includes a certain element.
-- @tparam table t The table that may include the element
-- @param element The element to look for
-- @treturn boolean Whether t includes element
function util.table.includes(t,element)
    local result = nil
    for _,v in pairs(t) do
        if(v == element)then result = v; break end
    end
    return result
end

--- Returns whether or not its argument is a table
-- @param t Any value
-- @treturn boolean Whether t is a table
function util.table.is(t)
    return type(t) == 'table'
end

--- Applies a function to every element of a table and collects the results in a new table.
-- Arguments passed to the function are Value, Key and the Table.
-- @tparam table t A table of values
-- @tparam function fn A function to apply to every value
-- @treturn table The return values of each call to fn
function util.table.map(t,fn)
    local new_t = {}
    for k,v in pairs(t) do
        new_t[k] = fn(v,k,t)
    end
    return new_t
end

--- Applies a function to each element of a tabla and throws away the results.
-- Arguments passed to the function are Value, Key and the Table.
-- @tparam table t A table of values
-- @tparam function fn A function to apply to every value
function util.table.for_each(t,fn)
    for k,v in pairs(t) do
        fn(v,k,t)
    end
end

--- Returns whether an object is an instance of a certain class.
-- @tparam table instance The object to check
-- @tparam string class The class name the object might be an instance of
-- @treturn boolean Whether the object is an instance of the class
function util.is_instance_of(instance,class)
    if not type(instance)=='table' then error("Argument #1 not an object (expected table, got "..type(instance)..")", 2) end
    return instance.__class_name == class
end

do
    local function return_first(first) return first end
    local function return_second(first, second) return second end
    
    --- Given a condition, returns a function that returns
    -- either its first argument (if condition is true)
    -- or its second argument (if condition is false)
    -- @param condition Any Lua value
    -- @treturn function One of the two functions described above
    function util.deco.if_condition(condition)
        if condition then
            return return_first
        else
            return return_second
        end
    end
end

--- Checks whether a value is nil and returns a default value if so.
-- @param value Value to check if is nil 
-- @param default Value to return if value param is nil
-- @return default if value is nil, value otherwise
function util.value.not_nil(value,default)
    return (value == nil and default) or value
end

return util
