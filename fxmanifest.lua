fx_version "adamant"

games { 'rdr3', 'gta5' }

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'QBR-Clothing'
version '1.0.0'

ui_page 'html/dist/index.html'

shared_scripts {
	'config.lua'
}

server_script 'server/sv_*.lua'

client_scripts {
	'overlays.lua',
	'client/cl_*.lua',
  	'cloth_hash_names.lua',
}

files {
	'html/dist/index.html',
	'html/dist/img/*.png',
	'html/dist/js/*.js',
}

dependencies {
	'qbr-core'
}
