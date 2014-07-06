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
            local subScope = Scope.new(scope.env, scope, scope.namespace)
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

    env.namespace:defineFunction('alias', function (scope, args)
        scope.namespace:defineFunction(args:arg(1):toString(), scope.namespace:getFunction(args:arg(2):toString()))
    end)

    env.namespace:defineFunction('block', function (scope, args)
        local count = args:count()
        for i = 1, count - 1 do
            args:arg(i)
        end
        if count > 0 then
            return args:arg(count)
        end
    end)

    env:eval([[
        (defun puts (string) {
            print(scope.lvars.string:toString())
        })
    ]])
end


return stdlib