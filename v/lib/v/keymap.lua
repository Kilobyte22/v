local class = require('oop-system').class
local keyboard = require('keyboard')
local unicode = require('unicode')

local Keymap = class('Keymap')

function Keymap:init(v)
    self.v = v
    self.mode = "control"
end

function Keymap:onKey(char, key)
    -- TODO: Make the keymap configurable
    if self.mode == "text" then
        if key == keyboard.keys.left then
            self.v.buf:moveCursor(-1, 0)
        elseif key == keyboard.keys.right then
            self.v.buf:moveCursor(1, 0)
        elseif key == keyboard.keys.up then
            self.v.buf:moveCursor(0, -1)
        elseif key == keyboard.keys.down then
            self.v.buf:moveCursor(0, 1)
        elseif key == keyboard.keys.f1 then
            self.mode = 'control'
            self.v.buf.mode = nil
            self.v.buf:verifyCursor()
            self.v.buf:setTempStatus('')
        elseif key == keyboard.keys.enter then
            self.v.buf:newline()
        elseif key == keyboard.keys.tab then
            -- TODO: Implement proper tab stops
            self.v.buf:insert("    ")
        elseif key == keyboard.keys.back then
            if self.v.buf:back() then
                self.v.buf:delete()
            end
        elseif key == keyboard.keys.delete then
            self.v.buf:delete()
        elseif not keyboard.isControl(char) then
            self.v.buf:insert(unicode.char(char))
        end
    elseif self.mode == "control" then
        if key == keyboard.keys.left then
            self.v.buf:moveCursor(-1, 0)
        elseif key == keyboard.keys.right then
            self.v.buf:moveCursor(1, 0)
        elseif key == keyboard.keys.up then
            self.v.buf:moveCursor(0, -1)
        elseif key == keyboard.keys.down then
            self.v.buf:moveCursor(0, 1)
        elseif key == keyboard.keys.back then
            self.v.buf:back()
        else
            if not keyboard.isControl(char) then
                local c = unicode.char(char)
                if c == ':' then
                    self.enabled = false
                    self.v.doCommand()
                    self.v.term.setCursorBlink(true)
                    self.enabled = true
                elseif c == 'i' then
                    self.v.buf:setTempStatus("-- INSERT --")
                    self.mode = 'text'
                    self.v.buf.mode = 'insert'
                end
            end
        end
    end
end

return Keymap
