local _ = function(...) return ... end

local term = require('term')
local os = require('os')

_(term.isAvailable() or os.exit(1))

v = {HOME = os.getenv('HOME') or '/home'}

-- TODO: load core of v
local vs = require('v-script')
local io = require('io')
local fs = require('filesystem')
local component = require('component')
local Buffer = require('v/buffer')
local event = require('event')
local exit


v.vscript = vs.Environment.new()
vs.stdlib.register(v.vscript)

local f = io.open('/usr/share/v/vs/main.vs')
local code = f:read('*a')
f:close()
v.vscript:eval(code)

if fs.exists(v.HOME..'/.vrc') then
    f = io.open(v.HOME..'/.vrc')
    local code = f:read('*a')
    f:close()
    v.vscript:eval(code)
end

function v.exit(code)
    v = nil
    exit = code or 0
end

local w, h = component.gpu.getResolution()
v.buf = Buffer.new('this\nis\na\ntest', term, {w = w, h = h}, component.gpu)
v.buf.lineNumbers = true
v.buf:update()

local function runLisp(code)
    return v.vscript:eval(code)
end

while true do
    if exit then
        os.exit(exit)
    end
    local line = v.buf:readLine()
    local s, m = pcall(runLisp, '('..line..')')
    if not s then
        v.buf:setStatus(m, 'error')
        os.sleep(4)
    end
end