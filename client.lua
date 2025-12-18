local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
marto = Tunnel.getInterface("desmanche")

local servico 
local cdsBlip = Config.blip
local screenshotURL = nil
local lastStart = 0 -- armazena o último tempo de início

CreateThread(function()
    while true do 
        local ped = PlayerPedId()
        local playerCds = GetEntityCoords(ped)
        local distancia = #(playerCds - vec3(cdsBlip.x, cdsBlip.y, cdsBlip.z))
        
        if distancia < 8 and not servico then
            DrawMarker(27, cdsBlip.x, cdsBlip.y, cdsBlip.z-1, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 255, 255, 200, false, false, 2, true)
            
            if distancia < 1.2 then 
                if IsControlJustPressed(0, 38) then
                    local now = GetGameTimer()
                    if now - lastStart >= 5000 then -- 5 segundos de cooldown
                        lastStart = now
                        exports['screenshot-basic']:requestScreenshotUpload(Config.webhookUploadDesmanche, "files[]", {
                            encoding = "jpg",
                            quality = 1
                        }, function(data)
                            local resp = json.decode(data)
                            local url = resp.attachments[1].url
                            -- Envia a screenshot para o servidor e armazena lá
                            TriggerServerEvent("desmanche:armazenarScreenshot", url)
                            TriggerEvent("Notify", "sucesso", "Va ate o local de desmanche e aperte [E]", 5000)
                            servico = true 
                            emServico()
                        end)
                    else
                        TriggerEvent("Notify", "negado", "Aguarde 5 segundos para iniciar novamente.", 3000)
                    end
                end
            end   
        end
        Wait(5)
    end 
end)

function emServico()
    CreateThread(function()
        while servico do 
            local ped = PlayerPedId()
            local playerCoords = GetEntityCoords(ped)
            local cdslugar = vec3(Config.lugar.x, Config.lugar.y, Config.lugar.z)
            local distancia = #(playerCoords - cdslugar)
            local veiculo = GetVehiclePedIsUsing(ped)
            local veiculote = GetVehiclePedIsIn(ped, true)

            if distancia < 5 then 
                DrawMarker(27, cdslugar.x, cdslugar.y, cdslugar.z-1, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 5.0, 255, 0, 255, 200, false, false, 2, true)
                
                if distancia < 3 then 
                    if IsPedInAnyVehicle(ped, true) and IsControlJustPressed(0, 38) then 
                        FreezeEntityPosition(veiculo, true) 
                        TriggerEvent("progress",10000,"DESMANCHANDO") 
                        -- Não há mais screenshot aqui, apenas espera o tempo total
                        Wait(10000)
                        local modelo = GetDisplayNameFromVehicleModel(GetEntityModel(veiculo))
                        local placa = GetVehicleNumberPlateText(veiculo)
                        DeleteEntity(veiculote)
                        marto.pagamentodesmanche(modelo, placa)
                        servico = false 
                        screenshotURL = nil
                        FreezeEntityPosition(ped, false)
                    end
                end     
            end
            Wait(5)
        end
    end)
end
