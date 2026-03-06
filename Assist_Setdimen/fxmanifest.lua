shared_script "@bt_defender/module/shared.lua"















fx_version 'adamant'

game 'gta5'


client_scripts {
	'config.lua',
   	'source/cl_main.lua',
	-- '@PolyZone/client.lua',
	-- '@PolyZone/ComboZone.lua',
	-- '@PolyZone/CircleZone.lua',
	-- '@PolyZone/BoxZone.lua',
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	'config.lua',
	'source/sv_main.lua',
}

ui_page 'Interface/ui.html'

files {
	'Interface/main.css',
	'Interface/main.js',
	'Interface/ui.html',
	'Interface/image/*.png',
	"Interface/sound/*.ogg",
}

lua54 'yes'