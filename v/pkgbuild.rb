id :'v'
name 'V Text Editor'

description 'A text editor inspired by vim, but very basic'

install 'bin/v.lua' => '/bin'
install Dir['share/v/vs/*.vs'] => '/share/v/vs'
install Dir['lib/v/*.lua'] => '/lib/v'

authors 'Kilobyte'

depend 'oop-system' => '/'
depend 'v-script' => '/'
