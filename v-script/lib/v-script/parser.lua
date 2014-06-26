local values = require('v-script/values')
local Sexp = require('v-script/s-exp')
local Token = require('v-script/token')

local parser = {}

function parser.parse(tokens)
    local pos = 0

    local function next()
        if pos > #tokens then
            error("Unexpected end of input")
        end
        pos = pos + 1
        return tokens[pos]
    end

    local function parseSexp()
        local args = {}
        while true do
            local t = next()
            local t_ = t.type
            if t_ == Token.Type.STRING then
                table.insert(args, values.String.new(t.value))
            elseif t_ == Token.Type.SYMBOL then
                table.insert(args, values.Symbol.new(t.value))
            elseif t_ == Token.Type.LUA then
                table.insert(args, values.Lua.new(t.value))
            elseif t_ == Token.Type.P_OPEN then
                table.insert(args, parseSexp())
            elseif t_ == Token.Type.P_CLOSE then
                return Sexp.new(args)
            else
                error("Unknown token type: "..t_)
            end
        end
    end
    assert(next().type == Token.Type.P_OPEN, 'expected (')
    return parseSexp()
end

return parser