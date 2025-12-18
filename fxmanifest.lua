fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'MartoFiel'
description 'Desmanche Simples'
version '1.0'

shared_script 'config.lua'

client_scripts {
    '@vrp/lib/utils.lua',
    'client.lua'
}

server_scripts {
    '@vrp/lib/utils.lua',
    'server.lua'
}
