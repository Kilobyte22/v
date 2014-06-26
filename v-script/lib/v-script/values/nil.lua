local class = require('oop-system').class

local Nil = class('Values::Nil')

function Nil:eval()
    return self
end

function Nil:toString()
    error("Attempt to implicitely convert nil into string")
end

function Nil:toNumber()
    error("Attempt to implicitely convert nil into number")
end

function Nil:toBool()
    return false
end

function Nil:toDebugString()
    return 'nil'
end

Nil.NIL = Nil.new() -- singleton

return Nil