local class = require('oop-system').class

local Boolean = class('Values::Boolean')

function Boolean:init(value)
    self.value = value
end

function Boolean:eval()
    return self
end

function Boolean:toString()
    return self.value and 'true' or 'false'
end

function Boolean:toNumber()
    error("Attempt to implicitely convert bool into number")
end

function Boolean:toBool()
    return self.value
end

function Boolean:toDebugString()
    return self:toString()
end

Boolean.TRUE = Boolean.new(true) -- singleton
Boolean.FALSE = Boolean.new(false) -- singleton

return Boolean