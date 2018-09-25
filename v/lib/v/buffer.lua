local class = require('oop-system').class

local Buffer = class('Buffer')
local math = require('math')

local function toLines(str)
    local t = {}
    local function helper(line) table.insert(t, line) return "" end
    helper((str:gsub("(.-)\r?\n", helper)))
    return t
end

function Buffer:init(text, term, size, gpu)
    local lines = toLines(text)
    self.lines = lines
    self.term = term
    self.lineNumbers = false
    self.scroll = {x = 0, y = 0 }
    self.cursor = {x = 1, y = 1}
    self.size = size
    self.mode = nil
    self.prompt = ':'
    self.status = nil
    self.tempStatus = nil
    self.gpu = gpu
    self.modified = false
end

function Buffer:getData()
    return table.concat(self.lines, "\n")
end

function Buffer:update()
    self.term.clear()
    self.lineNumberLength = 0
    if self.lineNumbers then
        for i = 1, self.size.h - 1 do
            if i + self.scroll.y > #self.lines then
                break
            end
            self.term.setCursor(1, i)
            local string = tostring(i + self.scroll.y)
            self.lineNumberLength = #string
            self.term.write(string, false)
        end
    end

    for i = 1, self.size.h - 1 do
        if i + self.scroll.y > #self.lines then
            break
        end
        self:drawLine(i + self.scroll.y)
    end

end

function Buffer:drawLine(linenum)
    local w = self.size.w
    local start = 1
    if self.lineNumbers then
        w = w - (self.lineNumberLength + 1)
        start = start + self.lineNumberLength + 1
    end
    if self.scroll.x < #self.lines[linenum] then
        self.term.setCursor(start, linenum - self.scroll.y)
        self.term.write(self.lines[linenum]:sub(self.scroll.x))
    end
end

function Buffer:readLine()
    self.mode = 'command'
    self.term.setCursor(1, self.size.h)
    self.term.clearLine()
    self.term.write(self.prompt)
    self.term.setCursor(1 + #self.prompt, self.size.h)
    local line = self.term.read(nil, false)
    self.mode = nil
    self.term.setCursorBlink(false)
    return line
end

function Buffer:setStatus(message)
    self.term.setCursor(1, self.size.h)
    self.term.clearLine()
    self.term.write(message)
end

function Buffer:moveCursor(x, y)
    local c = self.cursor
    c.x = c.x + x
    c.y = c.y + y
    self:verifyCursor()
end

function Buffer:verifyCursor()
    local c = self.cursor
    c.x = math.max(c.x, 1)
    c.y = math.max(c.y, 1)
    c.y = math.max(c.y, #(self.lines))
    c.x = math.min(c.x, #(self.lines[c.y + self.scroll.y]) + ((self.mode == 'insert') and 1 or 0))
    self:updateCursor()
end

function Buffer:updateCursor()
    local c = self.cursor
    self.term.setCursor(c.x, c.y)
end

Buffer.setTempStatus = Buffer.setStatus

return Buffer
