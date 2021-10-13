QBCore = exports['qb-core']:GetCoreObject()
camera = -1
isNewPlayer = false
local isLoggedIn = false
local PlayerData = {}
local staticClothingRoom = vector4(-767.76, -1295.21, 43.84, 286.88)


BeforePosition = nil

SkinData = {}
SkinData.skinDetails = {}
SkinData.overlays = {}
ClothesData = {}
PreviousSkinData = {}
PreviousClothesData = {}
PreviewSkinData = {}
PreviewClothesData = {}

Skins = {}
Skins.Male = {}
Skins.Female = {}
Clothes = {}
Clothes.Male = {}
Clothes.Female = {}



RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    if (NetworkIsInTutorialSession()) then
        NetworkEndTutorialSession()
        print('Removing from session')
    end
    PlayerData = QBCore.Functions.GetPlayerData()
    isLoggedIn = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)


RegisterNetEvent('qb-clothing:client:newPlayer')
AddEventHandler('qb-clothing:client:newPlayer', function()
    SetEntityVisible(PlayerPedId(), true)
    SetEntityHeading(PlayerPedId(), 105.68)
    isNewPlayer = true
    local sex = IsPedMale(PlayerPedId()) and 'Male' or 'Female'
    doesThisFixWorks(PlayerPedId(), sex)
    Wait(2000)
    openMenu(true, true, true)
end)


RegisterCommand('morning', function()
    NetworkClockTimeOverride(12, 0, 0, 1, false)
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if (isNewPlayer) then
            sleep = 1
            DrawLightWithRange(-558.71 - 5.0, -3781.6 - 5.0, 238.6 + 1.0, 255, 255, 204, 50.5, 50.0)
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    for k,v in pairs(Config.Stores) do
        if Config.Stores[k].shopType == "clothing" then
            exports['qb-prompts']:createPrompt(v.name, v.coords, 0xCEFD9220, 'Open Clothing Menu', {
                type = 'client',
                event = 'qb-clothing:client:openMenu',
                args = { false, true, false },
            })
            
            local clothingShop = N_0x554d9d53f696d002(1664425300, Config.Stores[k].coords)
            SetBlipSprite(clothingShop, 1195729388, 1)
            SetBlipScale(clothingShop, 0.7)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, "Clothing store")
        elseif Config.Stores[k].shopType == "outfits" then
            exports['qb-prompts']:createPrompt(v.name, v.coords, 0xF3830D8E, 'Open Outfits Menu', {
                type = 'client',
                event = 'qb-clothing:client:openOutfits',
                args = { false, true, false },
            })
        end

    end
end)

-- Faster insert
function insert(table, value)
    table[#table + 1] = value
end

RegisterNetEvent('qb-clothing:client:openMenu')
AddEventHandler('qb-clothing:client:openMenu', function(skinsMenu, clothesMenu, new)
    openMenu(skinsMenu, clothesMenu, new)
end)

RegisterNetEvent('qb-clothing:client:openOutfits')
AddEventHandler('qb-clothing:client:openOutfits', function()
    openOutfitsMenu()
end)

CreateThread(function()
    for _,v in pairs(cloth_hash_names) do
        if (v.category_hashname == "heads"
                or v.category_hashname == "eyes"
                or v.category_hashname == "teeth"
                or v.category_hashname == "BODIES_UPPER"
                or v.category_hashname == "BODIES_LOWER"
                or v.category_hashname == "beard"
                or v.category_hashname == "hair") then
            if (v.ped_type == 'male' and v.hashname ~= "" and v.is_multiplayer) then
                if (Skins.Male[v.category_hashname] == nil) then
                    Skins.Male[v.category_hashname] = {}
                end
                insert(Skins.Male[v.category_hashname], v.hash)
            elseif (v.ped_type == 'female' and v.hashname ~= "" and v.is_multiplayer) then
                if (Skins.Female[v.category_hashname] == nil) then
                    Skins.Female[v.category_hashname] = {}
                end
                insert(Skins.Female[v.category_hashname], v.hash)
            end
        else
            if (v.ped_type == "male" and v.is_multiplayer and v.category_hashname ~= "") then
                if (Clothes.Male[v.category_hashname] == nil) then
                    Clothes.Male[v.category_hashname] = {}
                end
                insert(Clothes.Male[v.category_hashname], v.hash)
            elseif (v.ped_type == "female" and v.is_multiplayer and v.category_hashname ~= "") then
                if (Clothes.Female[v.category_hashname] == nil) then
                    Clothes.Female[v.category_hashname] = {}
                end
                insert(Clothes.Female[v.category_hashname], v.hash)
            end
        end
    end
end)

function getSkinMaxValues()
    local sex = IsPedMale(PlayerPedId()) and 'Male' or 'Female'
    local skins = {}
    skins.skinDetails = {}
    skins.overlays = {}
    for k,v in pairs(Skins[sex]) do
        if (k ~= 'BODIES_UPPER' and k ~= 'BODIES_LOWER') then
            if (SkinData.skinDetails[k]) then
                insert(skins.skinDetails, {name = k, minValue = 0, maxValue = #v, currentValue = SkinData.skinDetails[k]})
            else
                insert(skins.skinDetails, {name = k, minValue = 0, maxValue = #v, currentValue = 0})
            end
        end
    end

    if (SkinData.skinDetails.skin) then
        insert(skins.skinDetails, {name = 'skin', minValue = 0, maxValue = 6, currentValue = SkinData.skinDetails.skin})
    else
        insert(skins.skinDetails, {name = 'skin', minValue = 0, maxValue = 6, currentValue = 0})
    end

    for k,v in pairs(Config.Features) do
        if (SkinData.skinDetails[k]) then
            insert(skins.skinDetails, {name = k, minValue = -100, maxValue = 100, currentValue = SkinData.skinDetails[k]})
        else
            insert(skins.skinDetails, {name = k, minValue = -100, maxValue = 100, currentValue = 0})
        end
    end

    skins.overlays.eyebrows = {}

    if (SkinData.overlays ~= nil and SkinData.overlays.eyebrows ~= nil) then
        --:TODO REFACTOR THIS SHIT CODE
        -- Eyebrows
        insert(skins.overlays.eyebrows, {name = 'eyebrows_type', minValue = 1, maxValue = 23, currentValue = SkinData.overlays.eyebrows.eyebrows_type})
        insert(skins.overlays.eyebrows, {name = 'eyebrows_visibility', minValue = 1, maxValue = 100, currentValue = SkinData.overlays.eyebrows.eyebrows_visibility})
        insert(skins.overlays.eyebrows, {name = 'eyebrows_color_palette', minValue = 1, maxValue = 25, currentValue = SkinData.overlays.eyebrows.eyebrows_color_palette})
        insert(skins.overlays.eyebrows, {name = 'eyebrows_main_color', minValue = 1, maxValue = 255, currentValue = SkinData.overlays.eyebrows.eyebrows_main_color})
        insert(skins.overlays.eyebrows, {name = 'eyebrows_second_color', minValue = 1, maxValue = 255, currentValue = SkinData.overlays.eyebrows.eyebrows_second_color})
        insert(skins.overlays.eyebrows, {name = 'eyebrows_third_color', minValue = 1, maxValue = 255, currentValue = SkinData.overlays.eyebrows.eyebrows_third_color})
    else
        insert(skins.overlays.eyebrows, {name = 'eyebrows_type', minValue = 1, maxValue = 23, currentValue = 1})
        insert(skins.overlays.eyebrows, {name = 'eyebrows_visibility', minValue = 1, maxValue = 100, currentValue = 1})
        insert(skins.overlays.eyebrows, {name = 'eyebrows_color_palette', minValue = 1, maxValue = 25, currentValue = 1})
        insert(skins.overlays.eyebrows, {name = 'eyebrows_main_color', minValue = 1, maxValue = 255, currentValue = 1})
        insert(skins.overlays.eyebrows, {name = 'eyebrows_second_color', minValue = 1, maxValue = 255, currentValue = 1})
        insert(skins.overlays.eyebrows, {name = 'eyebrows_third_color', minValue = 1, maxValue = 255, currentValue = 1})
    end

    skins.overlays.scars = {}
    if ( SkinData.overlays ~= nil and SkinData.overlays.scars ~= nil) then
        -- Scars
        insert(skins.overlays.scars,  {name = 'scars_type', minValue = 1, maxValue = 16, currentValue = SkinData.overlays.scars.scars_type})
        insert(skins.overlays.scars,  {name = 'scars_visibility', minValue = 1, maxValue = 100, currentValue = SkinData.overlays.scars.scars_visibility})
    else
        insert(skins.overlays.scars,  {name = 'scars_type', minValue = 1, maxValue = 16, currentValue = 1})
        insert(skins.overlays.scars,  {name = 'scars_visibility', minValue = 1, maxValue = 100, currentValue = 1})
    end

    skins.overlays.wrinkles = {}
    if (SkinData.overlays ~= nil and SkinData.overlays.wrinkles ~= nil) then
        -- Wrinkles
        insert(skins.overlays.wrinkles,  {name = 'wrinkles_type', minValue = 1, maxValue = 24, currentValue = SkinData.overlays.wrinkles.wrinkles_type})
        insert(skins.overlays.wrinkles,  {name = 'wrinkles_visibility', minValue = 1, maxValue = 100, currentValue = SkinData.overlays.wrinkles.wrinkles_visibility})
    else
        insert(skins.overlays.wrinkles,  {name = 'wrinkles_type', minValue = 1, maxValue = 24, currentValue = 1})
        insert(skins.overlays.wrinkles,  {name = 'wrinkles_visibility', minValue = 1, maxValue = 100, currentValue = 1})
    end

    skins.overlays.freckles = {}
    if (SkinData.overlays ~= nil and SkinData.overlays.freckles ~= nil) then
        -- Freckles
        insert(skins.overlays.freckles,  {name = 'freckles_type', minValue = 1, maxValue = 15, currentValue = SkinData.overlays.freckles.freckles_type})
        insert(skins.overlays.freckles,  {name = 'freckles_visibility', minValue = 1, maxValue = 100, currentValue = SkinData.overlays.freckles.freckles_visibility})
    else
        insert(skins.overlays.freckles,  {name = 'freckles_type', minValue = 1, maxValue = 15, currentValue = 1})
        insert(skins.overlays.freckles,  {name = 'freckles_visibility', minValue = 1, maxValue = 100, currentValue = 1})
    end

    skins.overlays.moles = {}
    if (SkinData.overlays ~= nil and SkinData.overlays.moles ~= nil) then
        -- Moles
        insert(skins.overlays.moles,  {name = 'moles_type', minValue = 1, maxValue = 16, currentValue = SkinData.overlays.moles.moles_type})
        insert(skins.overlays.moles,  {name = 'moles_visibility', minValue = 1, maxValue = 100, currentValue = SkinData.overlays.moles.moles_visibility})
    else
        insert(skins.overlays.moles,  {name = 'moles_type', minValue = 1, maxValue = 16, currentValue = 1})
        insert(skins.overlays.moles,  {name = 'moles_visibility', minValue = 1, maxValue = 100, currentValue = 1})
    end

    skins.overlays.pears = {}
    if (SkinData.overlays ~= nil and SkinData.overlays.pears ~= nil) then
        -- Pears
        insert(skins.overlays.pears,  {name = 'pears_type', minValue = 1, maxValue = 16, currentValue = SkinData.overlays.pears.pears_type})
        insert(skins.overlays.pears,  {name = 'pears_visibility', minValue = 1, maxValue = 100, currentValue = SkinData.overlays.pears.pears_visibility})
    else
        insert(skins.overlays.pears,  {name = 'pears_type', minValue = 1, maxValue = 16, currentValue = 1})
        insert(skins.overlays.pears,  {name = 'pears_visibility', minValue = 1, maxValue = 100, currentValue = 1})
    end

    skins.overlays.eyeliner = {}
    if (SkinData.overlays ~= nil and SkinData.overlays.eyeliner ~= nil) then
        -- Eyeliner
        insert(skins.overlays.eyeliner,  {name = 'eyeliner_type', minValue = 1, maxValue = 15, currentValue = SkinData.overlays.eyeliner.eyeliner_type})
        insert(skins.overlays.eyeliner,  {name = 'eyeliner_visibility', minValue = 1, maxValue = 100, currentValue = SkinData.overlays.eyeliner.eyeliner_visibility})
        insert(skins.overlays.eyeliner,  {name = 'eyeliner_color_palette', minValue = 1, maxValue = 25, currentValue = SkinData.overlays.eyeliner.eyeliner_color_palette})
        insert(skins.overlays.eyeliner,  {name = 'eyeliner_main_color', minValue = 1, maxValue = 255, currentValue = SkinData.overlays.eyeliner.eyeliner_main_color})
        insert(skins.overlays.eyeliner,  {name = 'eyeliner_second_color', minValue = 1, maxValue = 255, currentValue = SkinData.overlays.eyeliner.eyeliner_second_color})
        insert(skins.overlays.eyeliner,  {name = 'eyeliner_third_color', minValue = 1, maxValue = 255, currentValue = SkinData.overlays.eyeliner.eyeliner_third_color})
    else
        insert(skins.overlays.eyeliner,  {name = 'eyeliner_type', minValue = 1, maxValue = 15, currentValue = 1})
        insert(skins.overlays.eyeliner,  {name = 'eyeliner_visibility', minValue = 1, maxValue = 100, currentValue = 1})
        insert(skins.overlays.eyeliner,  {name = 'eyeliner_color_palette', minValue = 1, maxValue = 25, currentValue = 1})
        insert(skins.overlays.eyeliner,  {name = 'eyeliner_main_color', minValue = 1, maxValue = 255, currentValue = 1})
        insert(skins.overlays.eyeliner,  {name = 'eyeliner_second_color', minValue = 1, maxValue = 255, currentValue = 1})
        insert(skins.overlays.eyeliner,  {name = 'eyeliner_third_color', minValue = 1, maxValue = 255, currentValue = 1})
    end

    skins.overlays.shadows = {}
    if (SkinData.overlays ~= nil and SkinData.overlays.shadows ~= nil) then
        -- Shadows
        insert(skins.overlays.shadows,  {name = 'shadows_type', minValue = 1, maxValue = 5, currentValue = SkinData.overlays.shadows.shadows_type})
        insert(skins.overlays.shadows,  {name = 'shadows_visibility', minValue = 1, maxValue = 100, currentValue = SkinData.overlays.shadows.shadows_visibility})
        insert(skins.overlays.shadows,  {name = 'shadows_color_palette', minValue = 1, maxValue = 25, currentValue = SkinData.overlays.shadows.shadows_color_palette})
        insert(skins.overlays.shadows,  {name = 'shadows_main_color', minValue = 1, maxValue = 255, currentValue = SkinData.overlays.shadows.shadows_main_color})
        insert(skins.overlays.shadows,  {name = 'shadows_second_color', minValue = 1, maxValue = 255, currentValue = SkinData.overlays.shadows.shadows_second_color})
        insert(skins.overlays.shadows,  {name = 'shadows_third_color', minValue = 1, maxValue = 255, currentValue = SkinData.overlays.shadows.shadows_third_color})
    else
        insert(skins.overlays.shadows,  {name = 'shadows_type', minValue = 1, maxValue = 5, currentValue = 1})
        insert(skins.overlays.shadows,  {name = 'shadows_visibility', minValue = 1, maxValue = 100, currentValue = 1})
        insert(skins.overlays.shadows,  {name = 'shadows_color_palette', minValue = 1, maxValue = 25, currentValue = 1})
        insert(skins.overlays.shadows,  {name = 'shadows_main_color', minValue = 1, maxValue = 255, currentValue = 1})
        insert(skins.overlays.shadows,  {name = 'shadows_second_color', minValue = 1, maxValue = 255, currentValue = 1})
        insert(skins.overlays.shadows,  {name = 'shadows_third_color', minValue = 1, maxValue = 255, currentValue = 1})
    end

    skins.overlays.lipsticks = {}
    if (SkinData.overlays ~= nil and SkinData.overlays.lipsticks ~= nil) then
        -- Lipsticks
        insert(skins.overlays.lipsticks,  {name = 'lipsticks_type', minValue = 1, maxValue = 7, currentValue = SkinData.overlays.lipsticks.lipsticks_type})
        insert(skins.overlays.lipsticks,  {name = 'lipsticks_visibility', minValue = 1, maxValue = 100, currentValue = SkinData.overlays.lipsticks.lipsticks_visibility})
        insert(skins.overlays.lipsticks,  {name = 'lipsticks_color_palette', minValue = 1, maxValue = 25, currentValue = SkinData.overlays.lipsticks.lipsticks_color_palette})
        insert(skins.overlays.lipsticks,  {name = 'lipsticks_main_color', minValue = 1, maxValue = 255, currentValue = SkinData.overlays.lipsticks.lipsticks_main_color})
        insert(skins.overlays.lipsticks,  {name = 'lipsticks_second_color', minValue = 1, maxValue = 255, currentValue = SkinData.overlays.lipsticks.lipsticks_second_color})
        insert(skins.overlays.lipsticks,  {name = 'lipsticks_third_color', minValue = 1, maxValue = 255, currentValue = SkinData.overlays.lipsticks.lipsticks_third_color})
    else
        insert(skins.overlays.lipsticks,  {name = 'lipsticks_type', minValue = 1, maxValue = 7, currentValue = 1})
        insert(skins.overlays.lipsticks,  {name = 'lipsticks_visibility', minValue = 1, maxValue = 100, currentValue = 1})
        insert(skins.overlays.lipsticks,  {name = 'lipsticks_color_palette', minValue = 1, maxValue = 25, currentValue = 1})
        insert(skins.overlays.lipsticks,  {name = 'lipsticks_main_color', minValue = 1, maxValue = 255, currentValue = 1})
        insert(skins.overlays.lipsticks,  {name = 'lipsticks_second_color', minValue = 1, maxValue = 255, currentValue = 1})
        insert(skins.overlays.lipsticks,  {name = 'lipsticks_third_color', minValue = 1, maxValue = 255, currentValue = 1})
    end

    skins.overlays.blush = {}
    if (SkinData.overlays ~= nil and SkinData.overlays.blush ~= nil) then
        -- Blush
        insert(skins.overlays.blush,  {name = 'blush_type', minValue = 1, maxValue = 4, currentValue = SkinData.overlays.blush.blush_type})
        insert(skins.overlays.blush,  {name = 'blush_visibility', minValue = 1, maxValue = 100, currentValue = SkinData.overlays.blush.blush_visibility})
        insert(skins.overlays.blush,  {name = 'blush_color_palette', minValue = 1, maxValue = 25, currentValue = SkinData.overlays.blush.blush_color_palette})
        insert(skins.overlays.blush,  {name = 'blush_main_color', minValue = 1, maxValue = 255, currentValue = SkinData.overlays.blush.blush_main_color})
        insert(skins.overlays.blush,  {name = 'blush_second_color', minValue = 1, maxValue = 255, currentValue = SkinData.overlays.blush.blush_second_color})
        insert(skins.overlays.blush,  {name = 'blush_third_color', minValue = 1, maxValue = 255, currentValue = SkinData.overlays.blush.blush_third_color})
    else
        insert(skins.overlays.blush,  {name = 'blush_type', minValue = 1, maxValue = 4, currentValue = 1})
        insert(skins.overlays.blush,  {name = 'blush_visibility', minValue = 1, maxValue = 100, currentValue = 1})
        insert(skins.overlays.blush,  {name = 'blush_color_palette', minValue = 1, maxValue = 25, currentValue = 1})
        insert(skins.overlays.blush,  {name = 'blush_main_color', minValue = 1, maxValue = 255, currentValue = 1})
        insert(skins.overlays.blush,  {name = 'blush_second_color', minValue = 1, maxValue = 255, currentValue = 1})
        insert(skins.overlays.blush,  {name = 'blush_third_color', minValue = 1, maxValue = 255, currentValue = 1})
    end
    Wait(500)
    return skins
end

function getClothesMaxValues()
    local sex = IsPedMale(PlayerPedId()) and 'Male' or 'Female'
    local clothes = {}
    for k,v in pairs(Clothes[sex]) do
        if (ClothesData[k]) then
            insert(clothes, {name = k, minValue = 0, maxValue = #v, currentValue = ClothesData[k]})
        else
            insert(clothes, {name = k, minValue = 0, maxValue = #v, currentValue = 0})
        end
    end

    if (#clothes > 0) then
        return clothes
    end

    return false
end

RegisterCommand('openMenu', function()
    openMenu(true, true)
end)


function openOutfitsMenu()
    QBCore.Functions.TriggerCallback('qb-clothing:server:getOutfits', function(outfits)
        SendNUIMessage({
            type = 'setOutfits',
            data = outfits
        })
        SetNuiFocus(true, true)
    end)
end

function openMenu(skinMenu, clothesMenu, new)
    --TODO Refactor this code
    if (new) then
        local skins = getSkinMaxValues()
        local clothes = getClothesMaxValues()
        SendNUIMessage({
            type = 'setNew',
            data = {skins = skins, clothes = clothes, isNew = true}
        })
    elseif (skinMenu and not clothesMenu) then
        local skins = getSkinMaxValues()
        SendNUIMessage({
            type = 'setSkins',
            data = {skins = skins, isNew = false}
        })
    elseif (not skinMenu and clothesMenu) then
        clothingRoomTransition(staticClothingRoom, true)
        local clothes = getClothesMaxValues()
        SendNUIMessage({
            type = 'setClothes',
            data = {clothes = clothes, isNew = false}
        })
    elseif (skinMenu and clothesMenu) then
        local skins = getSkinMaxValues()
        local clothes = getClothesMaxValues()
        SendNUIMessage({
            type = 'setBoth',
            data = {skins = skins, clothes = clothes, isNew = false}
        })
    end
    SetNuiFocus(true, true)
    SetCursorLocation(0.9, 0.25)
    FreezeEntityPosition(PlayerPedId(), true)
    enableCam()
end

function clothingRoomTransition(coords, makeInvisible)
    if (makeInvisible) then
        if (not NetworkIsInTutorialSession()) then
            NetworkStartSoloTutorialSession()
            print('adding to session')
        end
    else
        if (NetworkIsInTutorialSession()) then
            NetworkEndTutorialSession()
            print('removing from session')
        end
    end
    local pedCoords = GetEntityCoords(PlayerPedId(), true)
    local heading = GetEntityHeading(PlayerPedId())
    BeforePosition = vector4(pedCoords.x, pedCoords.y, pedCoords.z, heading)
    DoScreenFadeOut(1000)
    while IsScreenFadingOut() do
        Wait(10)
    end
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z - 1.0)
    SetEntityHeading(PlayerPedId(), coords.w or 0.0)
    Wait(1000)
    DoScreenFadeIn(1000)
    while IsScreenFadingIn() do
        Wait(10)
    end
end

function enableCam()
    -- Camera
    local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 2.0, 0)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(camera, false)
    if(not DoesCamExist(camera)) then
        camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(camera, true)
        RenderScriptCams(true, false, 0, true, true)
        SetCamCoord(camera, coords.x, coords.y, coords.z + 0.5)
        SetCamRot(camera, 0.0, 0.0, GetEntityHeading(PlayerPedId()) + 180)
    end

    if customCamLocation ~= nil then
        SetCamCoord(camera, customCamLocation.x, customCamLocation.y, customCamLocation.z)
    end
end



function disableCam()
    RenderScriptCams(false, true, 250, 1, 0)
    DestroyCam(camera, false)
    SetNuiFocus(false, false)
    FreezeEntityPosition(PlayerPedId(), false)
end

function RequestAndSetModel(model)
    local requestedModel = GetHashKey(model)
    while not HasModelLoaded(requestedModel) do
        Wait(100)
        RequestModel(requestedModel)
    end
    Wait(200)
    Citizen.InvokeNative(0xED40380076A31506, PlayerId(), requestedModel, false)
    Citizen.InvokeNative(0x77FF8D35EEC6BBC4, PlayerPedId(), 0, 0)
    while not Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, PlayerPedId()) do
        Wait(1)
    end
end


exports('RequestAndSetModel', RequestAndSetModel)


AddEventHandler('onResourceStart', function(resource)
    if (GetCurrentResourceName() == resource) then
        isLoggedIn = true
        disableCam()
        DestroyAllCams(true)
    end
end)
