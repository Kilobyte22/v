local class = require('oop-system').class

local Namespace = class('Namespace')

function Namespace:init(parent, name)
    self.parent = parent
    self.name = name
    self.functions = {}
end

function Namespace:getFunction(name)
    return self.functions[name]
end

function Namespace:defineFunction(name, callback)
    self.functions[name] = callback
end

return Namespace