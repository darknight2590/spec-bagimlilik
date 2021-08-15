QBCore = nil
local ped = 0
Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        ped = PlayerPedId()
        Citizen.Wait(200)
    end
end)

local efekt = 0
local etki = false
local kontrol = false
local index = 1
local kanal = false

anim = "base"
dict = "timetable@maid@couch@"

local pos = 0
Citizen.CreateThread(function()
    while true do
        pos = GetEntityCoords(ped)
        Citizen.Wait(2000)
    end
end)

--[[RegisterCommand("bagimlilik", function(source,args) 
    QBCore.Functions.TriggerCallback('spec-bagimlilik:bagimli', function(skillInfo)
        if skillInfo then
            TriggerEvent("chatMessage", "SİSTEM", "error", "Uyuşturucu Bağımlılık Oranın: %"..tonumber(skillInfo))
        end
    end)
end)--]]

RegisterNetEvent("spec-bagimlilik:client:jointkullan")
AddEventHandler("spec-bagimlilik:client:jointkullan", function()
    QBCore.Functions.Progressbar("join_yak", "Joint'i yakıyorsun...", 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() 
        TriggerServerEvent('stadus_skills:addDrugs', GetPlayerServerId(PlayerId()), (0.20))
        TriggerServerEvent("QBCore:Server:RemoveItem", "joint", 1)
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["joint"], "remove")
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            TriggerEvent('animations:client:EmoteCommandStart', {"sigara"})
            Citizen.Wait(7500)
            SetTimecycleModifier("")
            ResetPedMovementClipset(PlayerPedId()) 
            QBCore.Functions.Notify("Uyuşturucu kullandığın için rahatladın...", "primary", 4500) 
            etki = false
        else
            TriggerEvent('animations:client:EmoteCommandStart', {"sigara"})
            Citizen.Wait(7500)
            SetTimecycleModifier("")  
            QBCore.Functions.Notify("Uyuşturucu kullandığın için rahatladın...", "primary", 4500) 
            etki = false
        end
        TriggerEvent("evidence:client:SetStatus", "weedsmell", 300)
    end)
end)

RegisterNetEvent("spec-bagimlilik:client:ignekullan")
AddEventHandler("spec-bagimlilik:client:ignekullan", function()
    QBCore.Functions.Progressbar("igne_kullan", "İğne Kullanıyorsun...", 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() 
        local player, distance = QBCore.Functions.GetClosestPlayer()
        if player ~= -1 and distance < 1.2 then
        local playerId = GetPlayerServerId(player)
            TriggerServerEvent("spec-bagimlilik:animasyon", playerId)
            TriggerServerEvent('spec-bagimlilik:removeDrugs', GetPlayerServerId(PlayerId()), (0.50), playerId)
            TriggerServerEvent("QBCore:Server:RemoveItem", "igne", 1)
            TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["igne"], "remove")
        end
    end)
end)

RegisterNetEvent("spec-bagimlilik:client:kanal")
AddEventHandler("spec-bagimlilik:client:kanal", function()
    QBCore.Functions.Progressbar("kan_al", "Kan Alıyorsun...", 1500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() 
        local player, distance = QBCore.Functions.GetClosestPlayer()
        if player ~= -1 and distance < 1.2 then
        local playerId = GetPlayerServerId(player)
            TriggerServerEvent("spec-bagimlilik:animasyonKAN", playerId)
        else
            QBCore.Functions.Notify("Yakında oyuncu yok..", "error") 
        end
    end)
end)




RegisterNetEvent("spec-bagimlilik:animasyonyapKAN")
AddEventHandler("spec-bagimlilik:animasyonyapKAN", function(playerId)
    QBCore.Functions.GetPlayerData(function(PlayerData)
        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)
        local Object = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 3.0, GetHashKey("v_med_bed1"), false, false, false)
        local objcoord = GetEntityCoords(Object)
        if #(PlayerPos- objcoord) < 2 then
            draggerId = playerId
            local dragger = PlayerPedId()
            RequestAnimDict("mini@repair")
            SetEntityHeading(PlayerPedId(), 69.03)
            
            while not HasAnimDictLoaded("mini@repair") do
                Citizen.Wait(10)
            end
            SetEntityCoords(PlayerPed, objcoord.x+1,objcoord.y,objcoord.z)
            TaskPlayAnim(dragger, "mini@repair", "fixing_a_ped", 8.0, -8.0, 100000, 49, 0, false, false, false)
            QBCore.Functions.Progressbar("kan_al", "Kan Alıyorsun..", 18000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() 
                TriggerServerEvent("QBCore:Server:AddItem", "kantupu", 1)
                TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["kantupu"], "add")
                TriggerServerEvent("spec-bagimlilik:kansonuc" , playerId)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})         
            end, function()
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})         
            QBCore.Functions.Notify("İptal edildi..", "error")
            end)
        else
            QBCore.Functions.Notify("Yakında tedavi uygulayabileceğin bir yatak yok..", "error")
        end
    end)
end)

-- KAN AL--
RegisterNetEvent('spec-bagimlilik:animasyonyapTargetKAN')
AddEventHandler('spec-bagimlilik:animasyonyapTargetKAN', function(playerId)
    QBCore.Functions.GetPlayerData(function(PlayerData)    
        draggerId = playerId
        local dragger = GetPlayerPed(GetPlayerFromServerId(playerId))
        local oyuncupos = GetEntityCoords(PlayerPedId())
        local inBedDicts = "amb@world_human_sunbathe@male@back@base"
        local inBedAnims = "base"
        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)
        local Object = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 3.0, GetHashKey("v_med_bed1"), false, false, false)
        local objcoord = GetEntityCoords(Object)
        if #(PlayerPos- objcoord) < 2 then

            LoadAnimation(inBedDicts)
            if Object ~= nil or Object ~= 0 then
                TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 8.0, 8.0, -1, 69, 1, false, false, false)
                AttachEntityToEntity(PlayerPed, Object, 0, 0, 0.0, 1.6, 0.0, 0.0, 360.0, 0.0, false, false, false, false, 2, true)
                IsLayingOnBed = true
                LoadAnimation(inBedDicts)
                if Object ~= nil or Object ~= 0 then
                TriggerServerEvent("qb-clothes:loadPlayerSkin")
                Citizen.Wait(1000)
                TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 8.0, 8.0, -1, 69, 1, false, false, false)
                AttachEntityToEntity(PlayerPed, Object, 0, 0, 0.0, 1.6, 0.0, 0.0, 360.0, 0.0, false, false, false, false, 2, true)
                IsLayingOnBed = true
            end
        end        
        QBCore.Functions.Progressbar("kan_al", "Kanın Alınıyor..", 18000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() 
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})         
        end, function()
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})         
            QBCore.Functions.Notify("İptal edildi..", "error")
            end)
        else
        QBCore.Functions.Notify("Yakında tedavi uygulayabileceğin bir yatak yok..", "error")
        end
     end)
end)

-- İĞNE --
RegisterNetEvent('spec-bagimlilik:animasyonyapTarget')
AddEventHandler('spec-bagimlilik:animasyonyapTarget', function(playerId)
    QBCore.Functions.GetPlayerData(function(PlayerData)    
        draggerId = playerId
        local dragger = GetPlayerPed(GetPlayerFromServerId(playerId))
        local oyuncupos = GetEntityCoords(PlayerPedId())
        local inBedDicts = "amb@world_human_sunbathe@male@back@base"
        local inBedAnims = "base"
        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)
        local Object = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 3.0, GetHashKey("v_med_bed1"), false, false, false)
        local objcoord = GetEntityCoords(Object)
        if #(PlayerPos- objcoord) < 2 then

            LoadAnimation(inBedDicts)
            if Object ~= nil or Object ~= 0 then
                TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 8.0, 8.0, -1, 69, 1, false, false, false)
                AttachEntityToEntity(PlayerPed, Object, 0, 0, 0.0, 1.6, 0.0, 0.0, 360.0, 0.0, false, false, false, false, 2, true)
                IsLayingOnBed = true
                LoadAnimation(inBedDicts)
                if Object ~= nil or Object ~= 0 then
                TriggerServerEvent("qb-clothes:loadPlayerSkin")
                Citizen.Wait(1000)
                TaskPlayAnim(PlayerPedId(), inBedDicts, inBedAnims, 8.0, 8.0, -1, 69, 1, false, false, false)
                AttachEntityToEntity(PlayerPed, Object, 0, 0, 0.0, 1.6, 0.0, 0.0, 360.0, 0.0, false, false, false, false, 2, true)
                IsLayingOnBed = true
            end
        end        
        QBCore.Functions.Progressbar("igne_vur", "İğne Vuruluyorsun..", 18000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() 
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})         
        end, function()
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})         
            QBCore.Functions.Notify("İptal edildi..", "error")
            end)
        else
        QBCore.Functions.Notify("Yakında tedavi uygulayabileceğin bir yatak yok..", "error")
        end
     end)
end)

RegisterNetEvent("spec-bagimlilik:client:ilackullan")
AddEventHandler("spec-bagimlilik:client:ilackullan", function()
    QBCore.Functions.Progressbar("ilac_ic", "İlaç Kullanıyorsun...", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() 
        TriggerServerEvent("QBCore:Server:RemoveItem", "uhap", 1)
        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["uhap"], "remove")
        if not etki then
            QBCore.Functions.Notify("İlaç bir işe yaramadı...", "primary", 4500) 
        else
            TriggerServerEvent('spec-bagimlilik:removeDrugs', GetPlayerServerId(PlayerId()), (0.50))
            SetTimecycleModifier("") 
            ResetPedMovementClipset(PlayerPedId()) 
            QBCore.Functions.Notify("İlaç kullandığın için rahatladın...", "primary", 4500) 
            etki = false
            Citizen.Wait(1800000)
            kontrol = false
        end
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            TriggerEvent('animations:client:EmoteCommandStart', {"drink"})
        else
            TriggerEvent('animations:client:EmoteCommandStart', {"drink"})
        end
    end)
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(6000000)
        print("kontrol")
        if not kontrol then
            QBCore.Functions.TriggerCallback('spec-bagimlilik:bagimli', function(skillInfo)
            local skill = tonumber(skillInfo)
            if skill >= 1 and skill <= 5 then
                local sans = math.random(1,100)
                if sans < 1 then
                SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                QBCore.Functions.Notify("Önceden uyuşturucu kullandığın için uyuşturucuya ihtiyaç duyuyorsun!", "primary", 4500) 
                while efekt < 11 do    
                    SetFlash(0, 0, 100, 7000, 100)
                    DoScreenFadeOut(100)
                    Citizen.Wait(100)
                    DoScreenFadeIn(500)
                    efekt = efekt + 1
                    Citizen.Wait(1500)
                end
                efekt = 0
            end
            elseif skill >= 6 and skill <= 15 then
            local sans = math.random(1,100)
            if sans < 100 then 
                etki = true                
                SetPedToRagdollWithFall(PlayerPedId(), 1500, 2000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                 QBCore.Functions.Notify("Önceden uyuşturucu kullandığın için belirtiler görünmeye başladı. Eğer iyileşmek istiyorsan uyuşturucu kullanımını azaltmalısın!", "primary", 4500) 
                 while efekt < 10 do 
                    SetTimecycleModifier("hud_def_desat_Trevor")
                    Citizen.Wait(1000)
                    SetTimecycleModifier("")  
                    efekt = efekt + 1
                    Citizen.Wait(1000)
                end
                SetPedToRagdollWithFall(PlayerPedId(), 1500, 2000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) 
                efekt = 0
            end
            elseif skill >= 16 and skill <= 30 then
                local sans = math.random(1,100)
                if sans < 8 then 
                    etki = true                
                    SetTimecycleModifier("hud_def_desat_Trevor")
                    SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                     QBCore.Functions.Notify("Önceden uyuşturucu kullandığın için belirtiler görünmeye başladı. Eğer iyileşmek istiyorsan uyuşturucu kullanımını azaltmalısın!", "primary", 4500) 
                     while efekt < 14 do 
                        SetTimecycleModifier("hud_def_desat_Trevor")
                        Citizen.Wait(1000)
                        SetTimecycleModifier("")  
                        efekt = efekt + 1
                        Citizen.Wait(1000)
                    end
                    SetPedToRagdollWithFall(PlayerPedId(), 1500, 2000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) 
                    efekt = 0
                end  
                elseif skill >= 31 and skill <= 50 then
                local sans = math.random(1,100)
                if sans < 12 then 
                    QBCore.Functions.Notify("Uyuşturucu komasına girdin! Geçmesini istiyorsan ilaç veya uyuşturucu kullanmalısın!", "primary", 3500) 
                    etki = true                
                    SetTimecycleModifier("hud_def_desat_Trevor")
                    SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                    while efekt < 16 do 
                        SetTimecycleModifier("hud_def_desat_Trevor")
                        Citizen.Wait(1000)
                        SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                        SetTimecycleModifier("")  
                        efekt = efekt + 1
                        Citizen.Wait(1000)
                    end
                    SetPedToRagdollWithFall(PlayerPedId(), 1500, 2000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) 
                    efekt = 0
                end
                elseif skill >= 51 and skill <= 80 then
                local sans = math.random(1,100)
                 if sans < 16 then 
                    QBCore.Functions.Notify("Uyuşturucu komasına girdin! Geçmesini istiyorsan ilaç veya uyuşturucu kullanmalısın!", "primary", 3500) 
                    etki = true                
                    SetTimecycleModifier("hud_def_desat_Trevor")
                    SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                    while efekt < 18 do 
                        SetTimecycleModifier("hud_def_desat_Trevor")
                        Citizen.Wait(1000)
                        SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                        SetTimecycleModifier("")  
                        efekt = efekt + 1
                        Citizen.Wait(1000)
                    end
                    SetPedToRagdollWithFall(PlayerPedId(), 1500, 2000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) 
                    efekt = 0
                     local sanskoma = math.random(1,100)
                        if sanskoma <= 15 then
                            agirkoma()
                        end
                    end 
                end
            end)
        end
    end
end)

function agirkoma()
    local ped = PlayerPedId()
    SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    QBCore.Functions.Notify("Uyuşturucu komasına girdin! Geçmesini istiyorsan ilaç veya uyuşturucu kullanmalısın!", "primary", 3500) 
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)    
    Citizen.Wait(10000)
    SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    QBCore.Functions.Notify("Uyuşturucu komasına girdin! Geçmesini istiyorsan ilaç veya uyuşturucu kullanmalısın!", "primary", 3500) 
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)   
    Citizen.Wait(10000)
    SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    QBCore.Functions.Notify("Uyuşturucu komasına girdin! Geçmesini istiyorsan ilaç veya uyuşturucu kullanmalısın!", "primary", 3500) 
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
    Citizen.Wait(10000)
    SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    QBCore.Functions.Notify("Uyuşturucu komasına girdin! Geçmesini istiyorsan ilaç veya uyuşturucu kullanmalısın!", "primary", 3500) 
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
    Citizen.Wait(10000)
    SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    QBCore.Functions.Notify("Uyuşturucu komasına girdin! Geçmesini istiyorsan ilaç veya uyuşturucu kullanmalısın!", "primary", 3500) 
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
    Citizen.Wait(10000)
    SetPedToRagdollWithFall(ped, 1500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    QBCore.Functions.Notify("Uyuşturucu komasına girdin! Geçmesini istiyorsan ilaç veya uyuşturucu kullanmalısın!", "primary", 3500) 
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
end



--[[local solucan = {

    [1] = {x = 259.0765, y = 6441.033, z = 31.785},
    [2] = {x = 267.9541, y = 6441.443, z = 31.901},
    [3] = {x = 275.5452, y = 6442.170, z = 31.983},
    [4] = {x = 255.6009, y = 6440.879, z = 31.738},
    [5] = {x = 248.7651, y = 6440.327, z = 31.637}

}

Citizen.CreateThread(function()
    while true do
            local sleep = 2000
            local isle = {}
            local random = math.random(1,100)
			if #(pos - vector3(solucan[index].x, solucan[index].y, solucan[index].z)) < 15 then
                sleep = 5			
                    DrawMarker(20, solucan[index].x, solucan[index].y, solucan[index].z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 151, 119, 62, 200, 0, 0, 0, 0)
                        
                        if #(pos - vector3(solucan[index].x, solucan[index].y, solucan[index].z)) < 1 then
                            sleep = 5		
                        DrawText3D(solucan[index].x, solucan[index].y, solucan[index].z + 0.3, "[~g~E~w~] Solucan Topla")	
     
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('animations:client:EmoteCommandStart', {"mechanic3"})
                        QBCore.Functions.Progressbar("spec_solucan", "Solucan topluyorsun..", 10000, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function() 
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        if random < 35 then
                            TriggerServerEvent("QBCore:Server:AddItem", "solucan", 2)
                            TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["solucan"], "add")
                        else
                            TriggerServerEvent("QBCore:Server:AddItem", "solucan", 1)
                            TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["solucan"], "add")
                        end
                    end)
                    index = math.random(1,5)
                end
            end
        end Citizen.Wait(sleep)	
    end
end)

local kenevir = {

    [1] = {x = 226.3767, y = 6339.540, z = 53.199},
    [2] = {x = 232.2494, y = 6338.933, z = 55.814},
    [3] = {x = 231.9999, y = 6332.458, z = 57.767},
    [4] = {x = 237.3732, y = 6329.947, z = 61.111},
    [5] = {x = 237.2765, y = 6325.089, z = 62.373}
}

Citizen.CreateThread(function()
    while true do
            local sleep = 2000
            local isle = {}
            local random = math.random(1,100)
			if #(pos - vector3(kenevir[index].x, kenevir[index].y, kenevir[index].z)) < 15 then
                sleep = 5			
                    DrawMarker(20, kenevir[index].x, kenevir[index].y, kenevir[index].z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 0, 144, 0, 200, 0, 0, 0, 0)
                        
                        if #(pos - vector3(kenevir[index].x, kenevir[index].y, kenevir[index].z)) < 1 then
                            sleep = 5		
                        DrawText3D(kenevir[index].x, kenevir[index].y, kenevir[index].z + 0.3, "[~g~E~w~] Kenevir Topla")	
     
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('animations:client:EmoteCommandStart', {"mechanic3"})
                        QBCore.Functions.Progressbar("spec_kenevir", "Kenevir topluyorsun..", 10000, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function() 
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        if random < 35 then
                            TriggerServerEvent("QBCore:Server:AddItem", "kenevir", 2)
                            TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["kenevir"], "add")
                        else
                            TriggerServerEvent("QBCore:Server:AddItem", "kenevir", 1)
                            TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["kenevir"], "add")
                        end
                    end)
                    index = math.random(1,5)
                end
            end
        end Citizen.Wait(sleep)	
    end
end)

local mantar = {

    [1] = {x = 541.2164, y = 6496.106, z = 30.052},
    [2] = {x = 543.4267, y = 6504.241, z = 29.931},
    [3] = {x = 545.0670, y = 6510.042, z = 29.884},
    [4] = {x = 543.2593, y = 6514.003, z = 29.944},
    [5] = {x = 543.3126, y = 6492.198, z = 30.240}

}


Citizen.CreateThread(function()
    while true do
            local sleep = 2000
            local isle = {}
            local random = math.random(1,100)
			if #(pos - vector3(mantar[index].x, mantar[index].y, mantar[index].z)) < 15 then
                sleep = 5			
                    DrawMarker(20, mantar[index].x, mantar[index].y, mantar[index].z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 172, 43, 76, 200, 0, 0, 0, 0)
                        
                        if #(pos - vector3(mantar[index].x, mantar[index].y, mantar[index].z)) < 1 then
                            sleep = 5		
                        DrawText3D(mantar[index].x, mantar[index].y, mantar[index].z + 0.3, "[~g~E~w~] Mantar Topla")	
     
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('animations:client:EmoteCommandStart', {"mechanic3"})
                        QBCore.Functions.Progressbar("spec_mantar", "Mantar topluyorsun..", 10000, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function() 
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        if random < 35 then
                            TriggerServerEvent("QBCore:Server:AddItem", "mantar", 2)
                            TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mantar"], "add")
                        else
                            TriggerServerEvent("QBCore:Server:AddItem", "mantar", 1)
                            TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mantar"], "add")
                        end
                    end)
                    index = math.random(1,5)
                end
            end
        end Citizen.Wait(sleep)	
    end
end)--]]


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if etki then
            RequestAnimSet('MOVE_M@DRUNK@VERYDRUNK')
            while not HasAnimSetLoaded('MOVE_M@DRUNK@VERYDRUNK') do
                Citizen.Wait(1)
            end
            SetPedMovementClipset(PlayerPedId(), 'MOVE_M@DRUNK@VERYDRUNK', 1.0)    
        end
    end
end)


function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.4, 0.24)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.01, 0.0+ factor, 0.03, 0, 0, 0, 76)
end

Citizen.CreateThread(function()

    RequestModel(GetHashKey("a_m_y_business_03"))
	
    while not HasModelLoaded(GetHashKey("a_m_y_business_03")) do
        Wait(1)
    end
	
	local npc = CreatePed(4, 0xA1435105, 305.0171, -595.499, 42.284, 28, false, true)
	
	SetEntityHeading(npc, 28)
	FreezeEntityPosition(npc, true)
	SetEntityInvincible(npc, true)
	SetBlockingOfNonTemporaryEvents(npc, true)
    while true do 
        local sleep = 2000
        local mesafe = #(pos - vector3(305.0171, -595.499, 42.284))
        if mesafe < 2 then
            sleep = 5
        DrawText3D(305.0171, -595.499, 44.284, "[E] İlaç Üreticisi")
            if IsControlJustReleased(0,38) and mesafe < 2 then
                QBCore.Functions.TriggerCallback('spec-bagimlilik:esyakontrol', function(cb)
                    if cb then
                        local miktar = 20
                      TriggerServerEvent("spec-bagimlilik:öde")
                      TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["solucan"], "remove")
                      TriggerServerEvent('QBCore:Server:RemoveItem', "solucan", miktar)
                      --
                      TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["kenevir"], "remove")
                      TriggerServerEvent('QBCore:Server:RemoveItem', "kenevir", miktar)
                      --
                      TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["mantar"], "remove")
                      TriggerServerEvent('QBCore:Server:RemoveItem', "mantar", miktar)
                    end
                end)
            end
        end
        Citizen.Wait(sleep)
    end
end)


RegisterNetEvent("spec-bagimlilik:sonuc")
AddEventHandler("spec-bagimlilik:sonuc", function(info, kangrubu, adsoy)
    kanal = true
    Citizen.Wait(1500)
    incele(info, kangrubu, adsoy)
end)

function incele(info, kangrubu, adsoy)
    Citizen.CreateThread(function()
        while kanal == true do
            local sleep = 2000
            local pos = GetEntityCoords(PlayerPedId())
            local mesafe = #(pos - vector3(249.9415, -1374.90, 39.534))
                    if mesafe < 2 then
                     sleep = 5
                        DrawText3D(249.9415, -1374.90, 39.534, "[E] Kanı İncele")
                            if IsControlJustReleased(0,38) and mesafe < 2 then
                                QBCore.Functions.TriggerCallback('spec-bagimlilik:kantüpükontrol', function(cb)
                                    if cb then
                                QBCore.Functions.Progressbar("kan_incele", "Kan İnceleniyor...", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = false,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {}, {}, {}, function() 
                                    TriggerEvent('chatMessage', "SYSTEM", "error", adsoy.. " adlı kişinin uyuşturucu bağımlılık yüzdesi " ..info.. "%")
                                    TriggerEvent('chatMessage', "SYSTEM", "error", adsoy.. " adlı kişinin kan grubu:  " ..kangrubu)  
                                    TriggerServerEvent("QBCore:Server:RemoveItem", "kantupu", 1)
                                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["kantupu"], "remove")
                                    kanal = false
                                end)
                            end
                        end)
                    end
                end
            Citizen.Wait(sleep)
        end
    end)
end

function LoadAnimation(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(100)
    end
end


