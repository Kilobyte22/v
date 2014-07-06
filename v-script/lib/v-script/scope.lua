local oop = require('oop-system') or error("Could not load class system")
local class = oop.class

local Scope = class('Scope')

local function setParent(self, key, value)
    local l = self.parent.lvars
    if l[key] then
        l[key] = value
    else
        rawset(self.lvars, key, value)
    end
end

function Scope:init(env, parent, namespace)
    self.env = env
    self.lvars = {}
    self.gvars = env.gvars
    self.evars = env.evars
    self.parent = parent
    self.functions = {}
    self.namespace = namespace or parent and parent.namespace or env.namespace
    if parent then
        setmetatable(self.lvars, {__index = parent.lvars, __newindex = setParent}) -- handle upvalues
    end
end

function Scope:resolveFunction(name)
    local f = self.functions[name]
    if not f then
        if self.parent then
            f = self.parent:resolveFunction()
        else
            f = self.env.namespace.functions[name]
        end
    end
    return f
end

function Scope:getFunction(name)
    return self.env.namespace:getFunction(name)
    --[[
    if name:sub(1, 1) == ':' then
        -- global functions only
        return self.env.namespace:getFunction(name) -- todo
    elseif name:match(':') then
        -- namespace specified
        local ns = self.env.namespace
        for e in name:gmatch("([^:]+)") do
            ns = ns:sub(e) or error('Unknown namespace: '..ns.name..':'..e)
        end
        return ns:getFunction(name)
    else
        return self:resolveFunction(name)
    end]]
end

function Scope:callFunction(name, args)
    return self:getFunction(name)(self, args)
end

return Scope