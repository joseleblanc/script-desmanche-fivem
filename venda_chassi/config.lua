Config = {}

Config.localVenda = { x = 1510.16, y = 6326.33, z = 24.6 } -- coordenadas de venda
Config.permissaoVenda = "mecanico.permissao"

Config.pagamentoChassi = {
    item = "dinheirosujo", -- item recebido pela venda
    valor = { min = 1000, max = 10000 }, -- valor por unidade (aleatório)
}
Config.npcVenda = {
    modelo = "u_m_m_partytarget", -- modelo do NPC
    heading = 50.0, -- direção que ele olha
    pos = { x = 1510.16, y = 6326.33, z = 24.6 } -- posição do NPC
}