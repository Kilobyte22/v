local class = require('oop-system').class

local values = {
    String = require('v-script/values/string'),
    Number = require('v-script/values/number'),
    Symbol = require('v-script/values/symbol'),
    Boolean = require('v-script/values/boolean'),
    Nil = require('v-script/values/nil'),
    Lua = require('v-script/values/lua')
}

return values