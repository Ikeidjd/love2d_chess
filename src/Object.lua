local Object = {
    _OBJECT_TYPE = "Object"
}

Object.__index = Object

local types = {
    Object = true
}

function Object:extend(subclass, type)
    assert(type, "Every object must have a type")
    assert(not types[type], "Type " .. type .. " already exists")
    types[type] = true

    subclass._OBJECT_TYPE = type
    subclass.__index = subclass

    setmetatable(subclass, self)
end

function Object:new(args)
    args = args or {}
    return setmetatable(args, self)
end

function Object:is_instance(class)
    assert(self:is_object(), "Attempted to call is_instance on a non-object")
    assert(class:is_class(), "Attempted to call is_instance with a non-class argument")

    local curTable = getmetatable(self)
    local type = class._OBJECT_TYPE

    while curTable._OBJECT_TYPE and curTable._OBJECT_TYPE ~= type do
        curTable = getmetatable(curTable)
    end

    return curTable._OBJECT_TYPE == type
end

function Object:is_class()
    return rawget(self, "_OBJECT_TYPE") ~= nil
end

function Object:is_object()
    return rawget(self, "_OBJECT_TYPE") == nil
end

function Object:tostring()
    local out = (self._OBJECT_TYPE or "Unknown Type") .. " {"

    for k, v in pairs(self) do
        if type(k) ~= "number" then
            if type(v) == "table" then v = Object.tostring(v) end
            out = out .. tostring(k) .. " = " .. tostring(v) .. ","
        end
    end

    return out .. "}"
end

function Object:shallowcopy()
    local out = setmetatable({}, getmetatable(self))

    for k, v in pairs(self) do
        out[k] = v
    end

    return out
end

function Object:deepcopy()
    local out = setmetatable({}, getmetatable(self))

    for k, v in pairs(self) do
        if type(v) == "table" then out[k] = Object.deepcopy(v)
        else out[k] = v end
    end

    return out
end

return Object
