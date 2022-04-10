fx_version 'adamant'
game 'gta5'

name 'VCAD LiveMap - FiveM'
author 'Tallerik'
version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'config.lua',
    'server.lua'
}

dependencies {
	'es_extended'
}