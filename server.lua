local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
desmanche = Tunnel.getInterface("desmanche")

marto = {}
Tunnel.bindInterface("desmanche", marto)

local screenshots = {}

RegisterServerEvent("desmanche:armazenarScreenshot")
AddEventHandler("desmanche:armazenarScreenshot", function(url)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        screenshots[user_id] = url
    end
end)

function marto.pagamentodesmanche (modelo, placa)
    local source = source 
    local user_id = vRP.getUserId(source)
    local valorRecebido = 0

    for k, v in pairs(Config.itens) do 
        local randomQuantidade = math.random(v.quantidade.min, v.quantidade.max)
        vRP.giveInventoryItem(user_id, v.item, randomQuantidade)
        TriggerClientEvent("Notify", source, "sucesso", "Você recebeu <b>" .. v.item ..  " <b> "  ..randomQuantidade.. "x" )

        if v.item == "dinheirosujo" then
            valorRecebido = randomQuantidade
        end
    end

    -- Recupera a screenshot armazenada
    local screenshotURL = screenshots[user_id] or ""
    screenshots[user_id] = nil -- Limpa após uso

    local embed = {
        {
            ["color"] = 16776960,
            ["title"] = "🚗 Desmanche Finalizado",
            ["description"] = "**ID:** "..user_id..
                             "\n**Modelo:** "..modelo..
                             "\n**Placa:** "..placa..
                             "\n**Valor Recebido:** $"..valorRecebido..
                             "\n**Data/Hora:** "..os.date("%d/%m/%Y %H:%M:%S"),
            ["image"] = { ["url"] = screenshotURL },
            ["footer"] = { ["text"] = "Logs Desmanche" }
        }
    }

    PerformHttpRequest(Config.webhookInicioDesmanche, function(err, text, headers) end, 'POST', json.encode({ username = "Leblanc", embeds = embed}), { ['Content-Type'] = 'application/json' })
end

-- Evento para finalizar embed
RegisterServerEvent("desmanche:enviarLogFinal")
AddEventHandler("desmanche:enviarLogFinal", function(imageURL, valorRecebido, modelo, placa)
    local source = source
    local user_id = vRP.getUserId(source)

    local embed = {
        {
            ["color"] = 16776960, -- amarelo
            ["title"] = "🚗 Desmanche Finalizado",
            ["description"] = "**ID:** "..user_id..
                             "\n**Modelo:** "..modelo..
                             "\n**Placa:** "..placa..
                             "\n**Valor Recebido:** $"..valorRecebido..
                             "\n**Data/Hora:** "..os.date("%d/%m/%Y %H:%M:%S"),
            ["image"] = { ["url"] = imageURL },
            ["footer"] = { ["text"] = "Logs Desmanche" }
        }
    }

    PerformHttpRequest(Config.webhookInicioDesmanche, function(err, text, headers) end, 'POST', json.encode({ username = "Desmanche Logs", embeds = embed}), { ['Content-Type'] = 'application/json' })
end)
