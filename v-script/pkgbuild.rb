id :'v-script'
name 'V-Script'

description 'A Lisp Like scripting language for OC'

install 'lib/v-script.lua' => '/lib'
install Dir['lib/v-script/*.lua'] => '/lib/v-script'
install Dir['lib/v-script/values/*.lua'] => '/lib/v-script/values'

depend :'oop-system'
