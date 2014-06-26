#!/usr/bin/env lua
package.path = package.path..';../oop-system/?.lua;lib/?.lua'

vs = require('v-script')

env = vs.Environment.new()
env:default()
env:eval('(puts "Hello world!")')
env:eval('(if true (puts w00t) (puts lame))')
env:eval('(if false (puts lame) (puts w00t))')
env:eval('(puts $SHELL)')