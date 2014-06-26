local class = require('oop-system').class

local function l(name)
    return require('v-script/values/'..name)
end
local String, Number, Boolean, Nil = l('string'), l('number'), l('boolean'), l('nil')
local Symbol = class('Values::Symbol')

function Symbol:init(value)
    self.value = value
end

function Symbol:eval(scope)
    local first = self.value:sub(1, 1)
    local rest = self.value:sub(2)
    if first == ':' then
        -- local var
        return scope.lvars[rest]
    elseif first == '_' then
        -- global var
        return scope.gvars[rest]
    elseif first == '$' then
        -- env var
        return scope.evars[rest]
    else
        local v = self.value
        if v == 'true' then
            return Boolean.TRUE
        elseif v == 'false' then
            return Boolean.FALSE
        elseif v == 'nil' or v == 'null' then
            return Nil.NIL
        else
            local n = tonumber(v)
            if n then
                return Number.new(n)
            else
                return String.new(v)
            end
        end
    end
end

function Symbol:toDebugString()
    return self.value
end

return Symbol