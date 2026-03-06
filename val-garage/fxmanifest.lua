shared_script "@bt_defender/module/shared.lua"


fx_version 'cerulean'

game 'gta5'

description 'val-garage'

version '1.0.0'
lua54 'yes'

files {
	'ui/ui.html',
	'ui/style.css',
	'ui/main.js',
	'ui/img/*.png',
	'ui/*.ttf',
	'ui/iconify-icon.min.js'
}

ui_page {
	'ui/ui.html'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config/main.lua',
	-- 'config/main.lua',
	'config/pound_detail.lua',
	'config/garage_detail.lua',
	'config/deposit_vehicle.lua',
	'config/vehicle_image.lua',
	'config/webhook.lua',
	'server/server.lua'
}

client_scripts {
	'@es_extended/locale.lua',	
	'config/main.lua',	
	'config/pound_detail.lua',
	'config/garage_detail.lua',
	'config/deposit_vehicle.lua',
	'config/vehicle_image.lua',
	'client/client.lua',
	'client/add.lua',
}

dependencies {
	'es_extended',
	-- 'esx_vehicleshop'
}
