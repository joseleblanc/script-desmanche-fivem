local npc = nil


CreateThread(function()
    while true do 
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local dist = #(coords - vec3(Config.localVenda.x, Config.localVenda.y, Config.localVenda.z))

        if dist < 10 then
            DrawMarker(27, Config.localVenda.x, Config.localVenda.y, Config.localVenda.z-1, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.7, 255, 215, 0, 200, false, false, 2, true)
            if dist < 1.5 then
                DrawText3D(Config.localVenda.x, Config.localVenda.y, Config.localVenda.z + 0.5, "[E] Vender Chassis")
                if IsControlJustPressed(0, 38) then
                    local quantidade = KeyboardInput("Quantidade para vender:", "", 5)
                    if quantidade ~= nil then
                        TriggerServerEvent("venda:confirmar", quantidade)
                    end
                end
            end
        end
        Wait(5)
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function KeyboardInput(textEntry, inputText, maxLength)
    AddTextEntry('FMMC_KEY_TIP1', textEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", inputText, "", "", "", maxLength)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        return GetOnscreenKeyboardResult()
    end
    return nil
end

CreateThread(function()
    RequestModel(Config.npcVenda.modelo)
    while not HasModelLoaded(Config.npcVenda.modelo) do
        Wait(100)
    end

    npc = CreatePed(4, Config.npcVenda.modelo, Config.npcVenda.pos.x, Config.npcVenda.pos.y, Config.npcVenda.pos.z-1, Config.npcVenda.heading, false, false)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
end)
