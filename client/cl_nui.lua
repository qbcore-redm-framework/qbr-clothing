RegisterNUICallback('rotateRight', function(_, cb)
    local heading = GetEntityHeading(PlayerPedId())
    SetEntityHeading(PlayerPedId(), heading + 30)
    cb(true)
end)

RegisterNUICallback('rotateLeft', function(_, cb)
    local heading = GetEntityHeading(PlayerPedId())
    SetEntityHeading(PlayerPedId(), heading - 30)
    cb(true)
end)


RegisterNUICallback('rotateCam', function(data, cb)
    local rotType = data.type
    local ped = PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(ped, 0, 2.0, 0)

    if rotType == "left" then
        SetEntityHeading(ped, GetEntityHeading(ped) - 10)
        SetCamCoord(camera, coords.x, coords.y, coords.z + 0.5)
        SetCamRot(camera, 0.0, 0.0, GetEntityHeading(ped) + 180)
    else
        SetEntityHeading(ped, GetEntityHeading(ped) + 10)
        SetCamCoord(camera, coords.x, coords.y, coords.z + 0.5)
        SetCamRot(camera, 0.0, 0.0, GetEntityHeading(ped) + 180)
    end
    cb(true)
end)


RegisterNUICallback('setupCam', function(data, cb)
    local value = data.value

    if value == 1 then
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.75, 0)
        SetCamCoord(camera, coords.x, coords.y, coords.z + 0.65)
    elseif value == 2 then
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0)
        SetCamCoord(camera, coords.x, coords.y, coords.z + 0.2)
    elseif value == 3 then
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0)
        SetCamCoord(camera, coords.x, coords.y, coords.z + -0.5)
    else
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 2.0, 0)
        SetCamCoord(camera, coords.x, coords.y, coords.z + 0.5)
    end
    cb(true)
end)


RegisterNUICallback('applySkin', function(data, cb)
    local skins = {}
    skins.skinDetails = {}
    skins.overlays = {}
    for k,v in pairs(data.values.skinDetails) do
        skins.skinDetails[v.name] = tonumber(v.currentValue)
    end

    for k,v in pairs(data.values.overlays) do
        skins.overlays[k] = {}
        for n,j in pairs(v) do
            skins.overlays[k][j.name] = tonumber(j.currentValue)
        end
    end
    if (next(skins) ~= nil) then
        loadSkin(PlayerPedId(), skins, false)
    end
    cb(true)
end)

RegisterNUICallback('applyClothes', function(data, cb)
    local clothes = {}
    for k,v in pairs(data.values) do
        if (clothes[v.name] == nil) then
            clothes[v.name] = tonumber(v.currentValue)
        end
    end
    if (next(clothes) ~= nil) then
        if (isNewPlayer) then
            loadClothes(PlayerPedId(), clothes, false)
        else
            loadClothes(PlayerPedId(), clothes, true)
        end
    end
    cb(true)
end)

RegisterNUICallback('applyOverlay', function(data, cb)
    local data1 = json.encode(data)
    local data2 = json.decode(data1)
    local overlays = {}
    for k,v in pairs(data2.value) do
        overlays[k] = {}
        for _,j in pairs(v) do
            overlays[k][j.name] = tonumber(j.currentValue)
        end
    end
    changeNotUpdate(PlayerPedId(), SkinData.skinDetails)
    applyOverlay(PlayerPedId(), overlays)
end)

RegisterNUICallback('close', function(data, cb)
    local saveClothes = data.saveClothes
    local saveSkin = data.saveSkin
    if (saveClothes) then
        ClothesData = PreviewClothesData
    end
    if (saveSkin) then
        SkinData = PreviewSkinData
    end
    loadSkin(PlayerPedId(), SkinData, false)
    loadClothes(PlayerPedId(), ClothesData, false)
    SetNuiFocus(false, false)
    RenderScriptCams(false, true, 250, 1, 0)
    DestroyCam(cam, false)
    clothingRoomTransition(BeforePosition, false)
    FreezeEntityPosition(PlayerPedId(), false)
    cb(true)
end)

RegisterNUICallback('closeMenu', function(data, cb)
    loadSkin(PlayerPedId(), SkinData, false)
    loadClothes(PlayerPedId(), ClothesData, false)
    SetNuiFocus(false, false)
    RenderScriptCams(false, true, 250, 1, 0)
    DestroyCam(cam, false)
    FreezeEntityPosition(PlayerPedId(), false)
    SetNuiFocus(false, false)
    cb(true)
end)

RegisterNUICallback('save', function(_, cb)
    local model = GetEntityModel(PlayerPedId())
    local skins = json.encode(PreviewSkinData)
    local clothes = json.encode(ClothesData)
    TriggerServerEvent('qbr-clothing:server:saveSkin', model, skins, clothes)
    if (isNewPlayer) then
        isNewPlayer = false
        DoScreenFadeOut(150)
        exports['qbr-weathersync']:enableSync()
        Wait(500)
        TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
        TriggerEvent('QBCore:Client:OnPlayerLoaded')
        SetEntityCoords(PlayerPedId(), 1359.575, -1301.451, 77.76775)
        disableCam()
        if (NetworkIsInTutorialSession()) then
            NetworkEndTutorialSession()
            print('Ending tutorial session')
        end
        Wait(1000)
        DoScreenFadeIn(150)

    end
    disableCam()
    cb(true)
end)

RegisterNUICallback('saveOutfit', function(data, cb)
    local model = GetEntityModel(PlayerPedId())
    local clothes = json.encode(PreviewClothesData)
    loadSkin(PlayerPedId(), SkinData)
    loadClothes(PlayerPedId(), PreviewClothesData, false)
    SetNuiFocus(false, false)
    RenderScriptCams(false, true, 250, 1, 0)
    DestroyCam(cam, false)
    clothingRoomTransition(BeforePosition, false)
    TriggerServerEvent('qbr-clothing:server:saveOutfit', data.outfitName, model, clothes)
    disableCam()
    cb(true)
end)

RegisterNUICallback('useOutfit', function(data, cb)
    loadSkin(PlayerPedId(), SkinData)
    loadClothes(PlayerPedId(), data.usingOutfit[1].skin, false)
    SetNuiFocus(false, false)
    cb(true)
end)


RegisterNUICallback('removeHat', function(_,cb)
    Citizen.InvokeNative(0xD710A5007C2AC539, PlayerPedId(), GetHashKey("hats"), 0)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, PlayerPedId(), 0, 1, 1, 1, 0)
    cb(true)
end)