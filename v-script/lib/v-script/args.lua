local oop = require('oop-system') or error("Could not load class system")
local class = oop.class

local Nil = require('v-script/values/nil')

local Args = class('Args')

function Args:init(scope, args)
    self.sexps = args
    self.scope = scope
    self.autoeval = true
    self.values = {}
end

function Args:count()
    return #self.sexps
end

function Args:arg(id)
    if self.autoeval then
        if not self.values[id] then
            self.values[id] = (self.sexps[id] or Nil.NIL):eval(self.scope)
        end
        return self.values[id]
    else
        return self.sexps[id] or Nil.NIL
    end
end

return Args