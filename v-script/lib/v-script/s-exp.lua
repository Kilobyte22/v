local oop = require('oop-system') or error("Could not load class system")
local Args = require('v-script/args')
local class = oop.class
local table = require('v-script/utils').table

local Sexp = class('Sexp')

function Sexp:init(array)
    self.data = array
end

function Sexp:eval(scope)
    local fname = self.data[1]:eval(scope):toString()
    local f = scope:getFunction(fname) or error('Unknown function '..fname)
    return f(scope, self:mkargs(scope))
end

function Sexp:mkargs(scope)
    local args = table.slice(self.data, 2)
    return Args.new(scope, args)
end

function Sexp:toDebugString()
    local tmp = "" -- where is my fucking .map -.-
    for i = 1, #self.data do
        if #tmp > 0 then
            tmp = tmp..' '
        end
        tmp = tmp..self.data[i]:toDebugString()
    end
    return "("..tmp..')'
end

return Sexp