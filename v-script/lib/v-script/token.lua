local oop = require('oop-system') or error("Could not load class system")
local class, enum = oop.class, oop.enum

local Token = class('Token')

Token.Type = enum ('Token.Type' ,{
    'P_OPEN',
    'P_CLOSE',
    'STRING',
    'SYMBOL',
    'LUA'
})

function Token:init(type, value, line)
    self.type = type
    self.value = value
    self.line = line
end

function Token:toDebugString()
    return "{"..Token.Type[self.type]..': '..self.value..' (line '..self.line..')}'
end

return Token