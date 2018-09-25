local class = require('oop-system').class

local Namespace = require('v-script/namespace')
local stdlib = require('v-script/stdlib')
local lexer = require('v-script/lexer')
local os = require('os')
local parser = require('v-script/parser')
local Scope = require('v-script/scope')
local String = require('v-script/values/string')
local Nil = require('v-script/values/nil')

local Environment = class('Environment')

local function envSet(table, key, value)
    os.setenv(key, value:toString())
end
local function envGet(table, key)
    local val = os.getenv(key)
    if val then
        return String.new(val)
    else
        return Nil.NIL
    end
end

function Environment:init()
    self.namespace = Namespace.new()
    self.gvars = {}
    self.evars = setmetatable({}, {__index = envGet, __newindex = envSet})
end

function Environment:default()
    stdlib.register(self)
end

function Environment:eval(code)
    local tokens = lexer.toTokens(code)
    local sexp = parser.parse(tokens)
    return sexp:eval(Scope.new(self))
end

return Environment
