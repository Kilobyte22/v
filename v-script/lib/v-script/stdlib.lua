local Scope = require('v-script/scope')

local Nil = require('v-script/values/nil')
local stdlib = {}

function stdlib.register(env)
    env.namespace:defineFunction('defun', function (scope, args)
        args.autoeval = false
        local name = args:arg(1):eval(scope)
        local argnames = args:arg(2)
        local callback = args:arg(3)
        scope.namespace:defineFunction(name:toString(), function (_, args)
            local subScope = Scope.new(scope.env, scope)
            for i = 1, #argnames.data do
                local n = argnames.data[i]:eval(scope):toString()
                rawset(subScope.lvars, n, args:arg(i))
            end
            return callback:eval(subScope)
        end)
        return name
    end)

    env.namespace:defineFunction('if', function (scope, args)
        args.autoeval = false
        if args:arg(1):eval(scope):toBool() then
            return args:arg(2):eval(scope)
        else
            return args:arg(3):eval(scope)
        end
    end)

    env.namespace:defineFunction('while', function (scope, args)
        args.autoeval = false
        local last = Nil.NIL
        while args:arg(1):eval(scope):toBool() do
            local subScope = Scope.new(scope.env, scope)
            rawset(subScope.lvars, 'last', last)
            last = args:arg(2):eval(subScope)
        end
        return last
    end)

    env:eval([[
        (defun puts (string) {
            print(scope.lvars.string:toString())
        })
    ]])
end


return stdlib