local class = require('oop-system').class

local Nil = require('v-script/values/nil')

local Lua = class('Values::Lua')

function Lua:init(code)
    self.func = load('return function(scope) '..code..' end')()
end

function Lua:eval(scope)
    return self.func(scope) or Nil.NIL
end

function Lua:toDebugString()
    return "{<lua chunk>}"
end

return Lua