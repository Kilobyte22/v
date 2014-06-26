local Token = require('v-script/token')

local lexer = {}

function lexer.toTokens(string)

    local line, sline = 1, nil
    local pos = 1
    local col = 0
    local tokens = {}
    local type, tmp
    local escaped = false
    local depth = 0

    local function next()
        -- next char please
        if pos <= #string then
            local ret = string:sub(pos, pos)
            pos = pos + 1
            col = col + 1
            if ret == '\n' then
                line = line + 1
                col = 1
            end
            return ret
        end
    end

    local function startToken(t)
        tmp = ''
        type = t
        sline = line
    end

    local function finishToken()
        if not type then
            return
        end
        table.insert(tokens, Token.new(type, tmp, sline))
        tmp, type = nil, nil
    end

    local function charToken(type, c)
        finishToken()
        startToken(type)
        tmp = c
        finishToken()
    end

    local function error(message)
        _G.error("input:"..line..":"..col..": parse error: "..message, 3)
    end

    while true do
        local c = next()
        if not c then
            if type == Token.Type.STRING then
                error('Unexpected end of input. Expected "')
            elseif type == Token.Type.LUA then
                error('Unexpected end of input. Expected }')
            end
            finishToken()
            return tokens
        end

        if type == Token.Type.STRING then
            if escaped then
                if c == 'n' then
                    c = '\n'
                elseif c == 't' then
                    c = '\t'
                end
                tmp = tmp..c
                escaped = false
            else
                if c == '"' then
                    finishToken()
                elseif c == '\\' then
                    escaped = true
                else
                    tmp = tmp..c
                end
            end
        elseif type == Token.Type.LUA then
            if c == '}' then
                depth = depth - 1
                if depth < 1 then
                    finishToken()
                else
                    tmp = tmp..'}'
                end
            elseif c == '{' then -- i am aware that this will break if someone uses } in a string or comment...
                depth = depth + 1
                tmp = tmp..'{'
            else
                tmp = tmp..c
            end
        else
            if c == '(' then
                -- opening parenthesis
                charToken(Token.Type.P_OPEN, '(')
            elseif c == ')' then
                -- closing parenthesis
                charToken(Token.Type.P_CLOSE, ')')
            elseif c == ' ' or c == '\n' or c == '\t' or c == '\r' then
                -- whitespace
                finishToken()
            elseif c == '{' then
                if type then
                    error("Unexpected {")
                else
                    startToken(Token.Type.LUA)
                    depth = 1
                end
            elseif c == '"' then
                if type then
                    error("Unexpected \"")
                else
                    startToken(Token.Type.STRING)
                end
            else
                if not type then
                    startToken(Token.Type.SYMBOL)
                end
                tmp = tmp..c
            end
        end

    end
end

return lexer