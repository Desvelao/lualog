local util = {
    table = {},
    deco = {},
    value = {}
}

function util.table.includes(t,element)
    local result = nil
    for _,v in pairs(t) do
        if(v == element)then result = v; break end
    end
    return result
end

function util.table.is(t)
    return type(t) == 'table'
end

function util.table.map(t,fn)
    local new_t = {}
    for k,v in pairs(t) do
        new_t[k] = fn(v,k,t)
    end
    return new_t
end

function util.table.for_each(t,fn)
    for k,v in pairs(t) do
        fn(v,k,t)
    end
end

function util.is_instance_of(instance,class)
    return instance.__class_name == class
end

do
    local function return_first(first) return first end
    local function return_second(first, second) return second end
    
    function util.deco.if_condition(condition)
        if condition then
            return return_first
        else
            return return_second
        end
    end
end

function util.value.not_nil(value,default)
    return (value == nil and default) or value
end

return util
