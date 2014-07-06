#!/usr/bin/env lua
package.path = package.path..';/home/stephan/coding/lua/Kilobyte-Programs/oop-system/lib/?.lua;lib/?.lua'

vs = require('v-script')

env = vs.Environment.new()
env:default()
--[[env:eval('(puts "Hello world!")')
env:eval('(if true (puts w00t) (puts lame))')
env:eval('(if false (puts lame) (puts w00t))')
env:eval('(puts $SHELL)')]]
env:eval([[
(block
    (defun abc () (puts "WOT"))
    (abc)
)
]])