local class = require('oop-system').class

local String = class('Values::String')

function String:init(value)
    self.value = value
end

function String:eval()
    return self
end

function String:toString()
    return self.value
end

function String:toNumber()
    error("Attempt to implicitely convert string into number")
end

function String:toBool()
    return true
end

function String:toDebugString()
    return '"'..self.value:gsub('\\', '\\\\'):gsub('"', '\\"')..'"'
end

function String:__plus(other)
    return self.value..other.value
end

return String