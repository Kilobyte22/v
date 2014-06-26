local class = require('oop-system').class

local Number = class('Values::Number')

function Number:init(value)
    self.value = value
end

function Number:eval()
    return self
end

function Number:toNumber()
    return self.value
end

function Number:toString()
    return tostring(self.value)
end

function Number:toBool()
    return true
end

function Number:toDebugString()
    return self:toString()
end

function Number:__plus(other)
    return Number.new(self.value + other.value)
end

return Number