QBCore = nil

TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)   


QBCore.Functions.CreateCallback('spec-bagimlilik:bagimli', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    exports['ghmattimysql']:execute('SELECT * FROM `players` WHERE `citizenid` = @identifier', {['@identifier'] = Player.PlayerData.citizenid}, 
    function(skillInfo)
          cb(skillInfo[1].drugs)
      end)
  end)


QBCore.Functions.CreateUseableItem("joint", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("spec-bagimlilik:client:jointkullan", source)
end)

QBCore.Functions.CreateUseableItem("uhap", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("spec-bagimlilik:client:ilackullan", source)
end)

QBCore.Functions.CreateUseableItem("igne", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("spec-bagimlilik:client:ignekullan", source)
end)

QBCore.Functions.CreateUseableItem("police_stormram", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("spec-bagimlilik:client:kanal", source)
end)

QBCore.Functions.CreateCallback('spec-bagimlilik:esyakontrol', function(source, callback)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName('kenevir') ~= nil and Player.Functions.GetItemByName('kenevir').amount >= 20 and Player.Functions.GetItemByName('mantar') ~= nil and Player.Functions.GetItemByName('mantar').amount >= 20 and Player.Functions.GetItemByName('solucan') ~= nil and Player.Functions.GetItemByName('solucan').amount >= 20 then     
        callback(true)
    else
        callback(false)
        TriggerClientEvent('QBCore:Notify', src, "Üzerinde gerekli eşyalar yok! Gereken eşyalar : 20x Kenevir / 20x Mantar / 20x Solucan")
    end
end)


RegisterServerEvent("spec-bagimlilik:öde")
AddEventHandler("spec-bagimlilik:öde",function()
    local Player = QBCore.Functions.GetPlayer(source)
    local miktar = 2500
    Player.Functions.AddMoney('cash', miktar, "hastane-ödeme")
    TriggerClientEvent('QBCore:Notify', source, "Malzemeleri sattığın için " ..miktar.."$ ödeme aldın.")
end)


RegisterServerEvent("spec-bagimlilik:removeDrugs")
AddEventHandler("spec-bagimlilik:removeDrugs", function(source, amount, playerId)
	local xPlayer = QBCore.Functions.GetPlayer(playerId)
	exports['ghmattimysql']:execute('SELECT * FROM `players` WHERE `citizenid` = @identifier', {['@identifier'] = xPlayer.PlayerData.citizenid}, function(skillInfo)
		exports['ghmattimysql']:execute('UPDATE `players` SET `drugs` = @drugs WHERE `citizenid` = @identifier',
			{
			['@drugs'] = (skillInfo[1].drugs - amount),
			['@identifier'] = xPlayer.PlayerData.citizenid
			}, function ()
			updatePlayerInfo(playerId)
		end)
	end)
end)

function updatePlayerInfo(playerId)
    local xPlayer  = QBCore.Functions.GetPlayer(playerId)
    exports['ghmattimysql']:execute('SELECT * FROM `players` WHERE `citizenid` = @identifier', {['@identifier'] = xPlayer.PlayerData.citizenid}, function(skillInfo)
        if ( skillInfo and skillInfo[1] ) then
            TriggerEvent('stadus_skills:sendPlayerSkills', playerId, skillInfo[1].stamina, skillInfo[1].strength, skillInfo[1].driving, skillInfo[1].shooting, skillInfo[1].fishing, skillInfo[1].drugs)
        end
    end)
end

RegisterServerEvent("spec-bagimlilik:animasyon")
AddEventHandler("spec-bagimlilik:animasyon",function(playerId)
    local oyuncu  = QBCore.Functions.GetPlayer(source)
    local yakinoyuncu  = QBCore.Functions.GetPlayer(playerId)

    TriggerClientEvent("spec-bagimlilik:animasyonyap", oyuncu.PlayerData.source, yakinoyuncu.PlayerData.source)
    TriggerClientEvent("spec-bagimlilik:animasyonyapTarget", yakinoyuncu.PlayerData.source, oyuncu.PlayerData.source)
end)

RegisterServerEvent("spec-bagimlilik:animasyonKAN")
AddEventHandler("spec-bagimlilik:animasyonKAN",function(playerId)
    local oyuncu  = QBCore.Functions.GetPlayer(source)
    local yakinoyuncu  = QBCore.Functions.GetPlayer(playerId)

    TriggerClientEvent("spec-bagimlilik:animasyonyapKAN", oyuncu.PlayerData.source, yakinoyuncu.PlayerData.source)
    TriggerClientEvent("spec-bagimlilik:animasyonyapTargetKAN", yakinoyuncu.PlayerData.source, oyuncu.PlayerData.source)
end)


RegisterServerEvent("spec-bagimlilik:kansonuc")
AddEventHandler("spec-bagimlilik:kansonuc",function(playerId)
    local src = source
    local oyuncu  = QBCore.Functions.GetPlayer(source)
    local yakinoyuncu  = QBCore.Functions.GetPlayer(playerId)
    
    exports['ghmattimysql']:execute('SELECT * FROM `players` WHERE `citizenid` = @identifier', {['@identifier'] = yakinoyuncu.PlayerData.citizenid}, 
    function(skillInfo)
        
        local kangrubu = yakinoyuncu.PlayerData.metadata.bloodtype
        local adsoy = yakinoyuncu.PlayerData.charinfo.firstname.." "..yakinoyuncu.PlayerData.charinfo.lastname
        local info = tonumber(skillInfo[1].drugs)
        TriggerClientEvent("spec-bagimlilik:sonuc", src, info, kangrubu, adsoy)  
    end)
end)


QBCore.Functions.CreateCallback('spec-bagimlilik:kantüpükontrol', function(source, callback)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName('kantupu') ~= nil and Player.Functions.GetItemByName('kantupu').amount >= 1 then     
        callback(true)
    else
        callback(false)
        TriggerClientEvent('QBCore:Notify', src, "Üzerinde inceyelebileceğin bir kan tüpü yok!")
    end
end)

