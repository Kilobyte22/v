id :'v-script'
name 'V-Script'

description 'A Lisp Like scripting language for OC'

install 'v-script.lua' => '/lib'
install Dir['v-script/lib/v-script/*.lua'] => '/lib/v-script'
install Dir['v-script/lib/v-script/values/*.lua'] => '/lib/v-script/values'

depend :'oop-system'
