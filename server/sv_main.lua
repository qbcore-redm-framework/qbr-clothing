local QBCore = exports['qbr-core']:GetCoreObject()

QBCore.Functions.CreateCallback('qbr-clothing:server:isPlayerNew', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local result = exports.oxmysql:executeSync('SELECT * FROM playerskins WHERE citizenid=@citizenid AND active=@active', {['@citizenid'] = Player.PlayerData.citizenid, ['@active'] = 1})
    if (result[1] == nil) then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent("qbr-clothing:server:saveSkin")
AddEventHandler('qbr-clothing:server:saveSkin', function(model, skin, clothes)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if model ~= nil and skin ~= nil then
        exports.oxmysql:execute('DELETE FROM playerskins WHERE citizenid=@citizenid', {['@citizenid'] = Player.PlayerData.citizenid}, function()
            exports.oxmysql:insert('INSERT INTO playerskins (citizenid, model, skin, clothes, active) VALUES (@citizenid, @model, @skin, @clothes, @active)', {
                ['@citizenid'] = Player.PlayerData.citizenid,
                ['@model'] = model,
                ['@clothes'] = clothes,
                ['@skin'] = skin,
                ['@active'] = 1
            })
        end)
    end
end)

RegisterServerEvent("qbr-clothing:server:saveOutfit")
AddEventHandler("qbr-clothing:server:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        exports.oxmysql:execute('INSERT INTO player_outfits (citizenid, outfitname, model, skin, outfitId) VALUES (@citizenid, @outfitname, @model, @skin, @outfitId)', {
            ['@citizenid'] = Player.PlayerData.citizenid,
            ['@outfitname'] = outfitName,
            ['@model'] = model,
            ['@skin'] = skinData,
            ['@outfitId'] = outfitId
        })
        local result = exports.oxmysql:fetchSync('SELECT * FROM player_outfits WHERE citizenid = @citizenid', { ['@citizenid'] = Player.PlayerData.citizenid })
        if result[1] ~= nil then
            TriggerClientEvent('qbr-clothing:client:reloadOutfits', src, result)
        else
            TriggerClientEvent('qbr-clothing:client:reloadOutfits', src, nil)
        end
    end
end)

RegisterServerEvent("qbr-clothing:server:removeOutfit")
AddEventHandler("qbr-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    exports.oxmysql:execute('DELETE player_outfits (citizenid, outfitname, model, skin, outfitId) VALUES (@citizenid, @outfitname, @model, @skin, @outfitId)', {
        ['@citizenid'] = Player.PlayerData.citizenid,
        ['@outfitname'] = outfitName,
        ['@model'] = model,
        ['@skin'] = skinData,
        ['@outfitId'] = outfitId
    })
    local result = exports.oxmysql:fetchSync('SELECT * FROM player_outfits WHERE citizenid = @citizenid', { ['@citizenid'] = Player.PlayerData.citizenid })
    if result[1] ~= nil then
        TriggerClientEvent('qbr-clothing:client:reloadOutfits', src, result)
    else
        TriggerClientEvent('qbr-clothing:client:reloadOutfits', src, nil)
    end
end)

QBCore.Functions.CreateCallback('qbr-clothing:server:getOutfits', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local retVal = {}

    local result = exports.oxmysql:executeSync('SELECT * FROM player_outfits WHERE citizenid=@citizenid', {['@citizenid'] = Player.PlayerData.citizenid})
    if result[1] ~= nil then
        for k, v in pairs(result) do
            result[k].skin = json.decode(result[k].skin)
            retVal[k] = v
        end
        cb(retVal)
    end
    cb(retVal)
end)