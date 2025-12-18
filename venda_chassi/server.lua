local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

RegisterServerEvent("venda:confirmar")
AddEventHandler("venda:confirmar", function(qtd)
    local source = source
    local user_id = vRP.getUserId(source)
    qtd = tonumber(qtd)

    if user_id and qtd and qtd > 0 then
        if vRP.hasPermission(user_id, Config.permissaoVenda) then
            if vRP.tryGetInventoryItem(user_id, "ChassiRaspado", qtd) then
                local total = 0
                for i = 1, qtd do
                    local precoUnitario = math.random(Config.pagamentoChassi.valor.min, Config.pagamentoChassi.valor.max)
                    total = total + precoUnitario
                end
                vRP.giveInventoryItem(user_id, Config.pagamentoChassi.item, total)
                TriggerClientEvent("Notify", source, "sucesso", "Você vendeu "..qtd.." Chassis e recebeu "..total.."x "..Config.pagamentoChassi.item..".")
            else
                TriggerClientEvent("Notify", source, "negado", "Você não possui essa quantidade de Chassis Raspado.")
            end
        else
            TriggerClientEvent("Notify", source, "negado", "Você não tem permissão para vender aqui.")
        end
    end
end)
