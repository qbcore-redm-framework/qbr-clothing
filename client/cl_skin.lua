local LegsComponent = 0
local TorsoComponent = 0
local textureId = -1
--TODO Refactor Duplicate Code
function loadSkin(ped, data, preview)
    if (preview) then
        Citizen.CreateThread(function()
            local isReady = false
            while not isReady do
                SetEntityAlpha(ped, 0)
                local sex = IsPedMale(ped) and 'Male' or 'Female'
                doesThisFixWorks(ped, sex)
                loadSkincolor(ped, data.skinDetails)
                loadHeads(ped, data.skinDetails)
                loadHair(ped, data.skinDetails)
                loadEyes(ped, data.skinDetails)
                loadBodySize(ped, data.skinDetails)
                loadFeatures(ped, data.skinDetails)
                applyOverlay(ped, data.overlays)
                Wait(500)
                Citizen.InvokeNative(0x704C908E9C405136, ped)
                Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, 0, 1, 1, 1, 0)
                loadHeight(ped, data.skinDetails)
                SkinData = data
                SetEntityAlpha(ped, 255)
                isReady = Citizen.InvokeNative(0xFB4891BD7578CDC1 , ped, tonumber(0x378AD10C))
            end
        end)
    else
        loadSkincolor(ped, data.skinDetails)
        loadHeads(ped, data.skinDetails)
        loadHair(ped, data.skinDetails)
        loadEyes(ped, data.skinDetails)
        loadBodySize(ped, data.skinDetails)
        loadFeatures(ped, data.skinDetails)
        Citizen.CreateThread(function()
            if (data.overlays ~= nil) then
                applyOverlay(ped, data.overlays)
            end
        end)
        PreviewSkinData = data
    end
end

function loadHeight(ped, data)
    if (data.height) then
        local value = tonumber(data.height)
        SetPedScale(ped, value / 100)
    end
end

function loadSkincolor(ped, data)
    local value = tonumber(data.skin)
    local sex = IsPedMale(ped) and 'Male' or 'Female'
    if (sex == 'Male') then
        if (value == 1) then
            LegsComponent = Skins[sex]['BODIES_LOWER'][1]
            TorsoComponent = Skins[sex]['BODIES_UPPER'][1]
            texture_types["male"].albedo = GetHashKey("mp_head_mr1_sc08_c0_000_ab")
        elseif (value == 2) then
            LegsComponent = Skins[sex]['BODIES_LOWER'][3]
            TorsoComponent = Skins[sex]['BODIES_UPPER'][3]
            texture_types["male"].albedo = GetHashKey("head_mr1_sc02_rough_c0_002_ab")
        elseif (value == 3) then
            LegsComponent = Skins[sex]['BODIES_LOWER'][8]
            TorsoComponent = Skins[sex]['BODIES_UPPER'][8]
            texture_types["male"].albedo = GetHashKey("MP_head_mr1_sc01_c0_000_ab")
        elseif (value == 4) then
            LegsComponent = Skins[sex]['BODIES_LOWER'][10]
            TorsoComponent = Skins[sex]['BODIES_UPPER'][10]
            texture_types["male"].albedo = GetHashKey("MP_head_mr1_sc03_c0_000_ab")
        elseif (value == 5) then
            LegsComponent = Skins[sex]['BODIES_LOWER'][11]
            TorsoComponent = Skins[sex]['BODIES_UPPER'][11]
            texture_types["male"].albedo = GetHashKey("head_mr1_sc04_rough_c0_002_ab")
        elseif (value == 6) then
            LegsComponent = Skins[sex]['BODIES_LOWER'][30]
            TorsoComponent = Skins[sex]['BODIES_UPPER'][30]
            texture_types["male"].albedo = GetHashKey("MP_head_mr1_sc05_c0_000_ab")
        end
    else
        if (value == 1) then
            LegsComponent = Skins[sex]['BODIES_LOWER'][1]
            TorsoComponent = Skins[sex]['BODIES_UPPER'][1]
            texture_types["female"].albedo = GetHashKey("mp_head_fr1_sc08_c0_000_ab")
        elseif (value == 2) then
            LegsComponent = Skins[sex]['BODIES_LOWER'][3]
            TorsoComponent = Skins[sex]['BODIES_UPPER'][3]
            texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc03_c0_000_ab")
        elseif (value == 3) then
            LegsComponent = Skins[sex]['BODIES_LOWER'][8]
            TorsoComponent = Skins[sex]['BODIES_UPPER'][8]
            texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc01_c0_000_ab")
        elseif (value == 4) then
            LegsComponent = Skins[sex]['BODIES_LOWER'][10]
            TorsoComponent = Skins[sex]['BODIES_UPPER'][10]
            texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc03_c0_000_ab")
        elseif (value == 5) then
            LegsComponent = Skins[sex]['BODIES_LOWER'][11]
            TorsoComponent = Skins[sex]['BODIES_UPPER'][11]
            texture_types["female"].albedo = GetHashKey("head_fr1_sc04_rough_c0_002_ab")
        elseif (value == 6) then
            LegsComponent = Skins[sex]['BODIES_LOWER'][30]
            TorsoComponent = Skins[sex]['BODIES_UPPER'][30]
            texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc05_c0_000_ab")
        end
    end
    Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, tonumber(TorsoComponent), false, true, true)
    Wait(10)
    Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, tonumber(LegsComponent), false, true, true)
    Wait(100)
    Citizen.InvokeNative(0x704C908E9C405136, ped)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, 0, 1, 1, 1, 0)
end

function loadHeads(ped, data)
    local sex = IsPedMale(ped) and 'Male' or 'Female'
    local value = tonumber(data.heads)
    local hash = Skins[sex]['heads'][value]
    Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, tonumber(hash), false, true, true)
end

function loadEyes(ped, data)
    local sex = IsPedMale(ped) and 'Male' or 'Female'
    local value = tonumber(data.eyes)
    local hash = Skins[sex]['eyes'][value]
    Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, tonumber(hash), false, true, true)
end

function loadHair(ped, data)
    local sex = IsPedMale(ped) and 'Male' or 'Female'
    local hairValue = tonumber(data.hair)
    local hairHash = Skins[sex]['hair'][hairValue]
    Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, tonumber(hairHash), false, true, true)
    if (sex == 'Male') then
        local beardValue = tonumber(data.beard)
        local beardHash = Skins[sex]['beard'][beardValue]
        Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, tonumber(beardHash), false, true, true)
    end
end

function loadBodySize(ped, data)
    local value = tonumber(data.body_size)
    Citizen.InvokeNative(0x1902C4CFCC5BE57C, ped, Config.BodyTypes[value])
end

function loadFeatures(ped, data)
    for k,v in pairs(data) do
        if (Config.Features[k]) then
            Citizen.InvokeNative(0x5653AB26C82938CF, ped, Config.Features[k], v / 100)
        end
    end
end

function doesThisFixWorks(ped, sex)
    Citizen.InvokeNative(0x77FF8D35EEC6BBC4,ped,0,0)
    while not Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, ped) do
        Wait(1000)
    end
    Citizen.InvokeNative(0x0BFA1BD465CDFEFD, ped)
    if IsPedMale(ped) then
        Citizen.InvokeNative(0xD3A7B003ED343FD9 , ped,   tonumber(Skins[sex]["BODIES_UPPER"][1]), false, true, true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9 , ped,   tonumber(Skins[sex]["BODIES_LOWER"][1]), false, true, true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9 , ped,   tonumber(Skins[sex]["heads"][1]), false, true, true)
    else
        Citizen.InvokeNative(0xD3A7B003ED343FD9 , ped,   tonumber(Skins[sex]["BODIES_UPPER"][1]), false, true, true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9 , ped,   tonumber(Skins[sex]["BODIES_LOWER"][1]), false, true, true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9 , ped,   tonumber(Skins[sex]["heads"][1]), false, true, true)
    end
    Citizen.InvokeNative(0xD710A5007C2AC539, ped, 0x1D4C528A, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, ped, 0x3F1F01E5, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, ped, 0xDA0E2C55, 0)
    Citizen.InvokeNative(0x704C908E9C405136, ped)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, 0, 1, 1, 1, 0)
end


function isPedUsingComponent(ped)
    local results = true
    if not Citizen.InvokeNative(0xFB4891BD7578CDC1, ped, tonumber(0x378AD10C)) or
            not Citizen.InvokeNative(0xFB4891BD7578CDC1, ped, tonumber(0xEA24B45E)) or
            not Citizen.InvokeNative(0xFB4891BD7578CDC1, ped, tonumber(0x823687F5)) or
            not Citizen.InvokeNative(0xFB4891BD7578CDC1, ped, tonumber(0xB3966C9)) or
            not Citizen.InvokeNative(0xFB4891BD7578CDC1, ped, tonumber(0x864B03AE)) then
        results = false
    end
    return results
end

function toggleOverlayChange(_name,_visibility,_tx_id,_tx_normal,_tx_material,_tx_color_type,_tx_opacity,_tx_unk,_palette_id,_palette_color_primary,_palette_color_secondary,_palette_color_tertiary,_var,_opacity, _targets)
    Citizen.CreateThread(function()
        local name = _name
        local visibility = _visibility
        local tx_id = _tx_id
        local tx_normal = _tx_normal
        local tx_material = _tx_material
        local tx_color_type = _tx_color_type
        local tx_opacity = _tx_opacity
        local tx_unk = _tx_unk
        local palette_id = _palette_id
        local palette_color_primary = _palette_color_primary
        local palette_color_secondary = _palette_color_secondary
        local palette_color_tertiary = _palette_color_tertiary
        local var = _var
        local opacity = _opacity
        local target = _targets
        for k,v in pairs(overlay_all_layers) do
            if v.name==name then
                v.visibility = visibility
                if visibility ~= 0 then
                    v.tx_normal = tx_normal
                    v.tx_material = tx_material
                    v.tx_color_type = tx_color_type
                    v.tx_opacity =  tx_opacity
                    v.tx_unk =  tx_unk
                    if tx_color_type == 0 then
                        v.palette = color_palettes[palette_id][1]
                        v.palette_color_primary = palette_color_primary
                        v.palette_color_secondary = palette_color_secondary
                        v.palette_color_tertiary = palette_color_tertiary
                    end
                    if name == "shadows" or name == "eyeliners" or name == "lipsticks" then
                        v.var = var
                        v.tx_id = overlays_info[name][1].id
                    else
                        v.var = 0
                        v.tx_id = overlays_info[name][tx_id].id
                    end
                    v.opacity = opacity
                end
            end
        end
        local ped = target
        if IsPedMale(ped) then
            current_texture_settings = texture_types["male"]
        else
            current_texture_settings = texture_types["female"]
        end
        if textureId ~= -1 then
            Citizen.InvokeNative(0xB63B9178D0F58D82,textureId)  -- reset texture
            Citizen.InvokeNative(0x6BEFAA907B076859,textureId)  -- remove texture
        end
        textureId = Citizen.InvokeNative(0xC5E7204F322E49EB,current_texture_settings.albedo, current_texture_settings.normal, current_texture_settings.material);  -- create texture
        for k,v in pairs(overlay_all_layers) do
            if v.visibility ~= 0 then
                local overlay_id = Citizen.InvokeNative(0x86BB5FF45F193A02,textureId, v.tx_id , v.tx_normal, v.tx_material, v.tx_color_type, v.tx_opacity,v.tx_unk); -- create overlay
                if v.tx_color_type == 0 then
                    Citizen.InvokeNative(0x1ED8588524AC9BE1,textureId,overlay_id,v.palette);    -- apply palette
                    Citizen.InvokeNative(0x2DF59FFE6FFD6044,textureId,overlay_id,v.palette_color_primary,v.palette_color_secondary,v.palette_color_tertiary)  -- apply palette colours
                end
                Citizen.InvokeNative(0x3329AAE2882FC8E4,textureId,overlay_id, v.var);  -- apply overlay variant
                Citizen.InvokeNative(0x6C76BC24F8BB709A,textureId,overlay_id, v.opacity); -- apply overlay opacity
            end
        end
        while not Citizen.InvokeNative(0x31DC8D3F216D8509,textureId) do  -- wait till texture fully loaded
            Citizen.Wait(0)
        end
        Citizen.InvokeNative(0x0B46E25761519058,ped,GetHashKey("heads"),textureId)  -- apply texture to current component in category "heads"
        Citizen.InvokeNative(0x92DAABA2C1C10B0E,textureId)      -- update texture
        Citizen.InvokeNative(0xCC8CA3E88256E58F,ped, 0, 1, 1, 1, false);  -- refresh ped components
    end)
end


function applyOverlay(ped, data)
    if (data ~= nil) then

        if (data.eyebrows ~= nil and data.eyebrows.eyebrows_type > 1) then
            toggleOverlayChange("eyebrows", 1, tonumber(data.eyebrows.eyebrows_type), 0, 0, 0, 1.0, 0, tonumber(data.eyebrows.eyebrows_color_palette), tonumber(data.eyebrows.eyebrows_main_color), tonumber(data.eyebrows.eyebrows_second_color), tonumber(data.eyebrows.eyebrows_third_color), tonumber(0), tonumber(data.eyebrows.eyebrows_visibility / 100), ped)
            Wait(50)
        end

        if (data.scars ~= nil and data.scars.scars_type > 1) then
            toggleOverlayChange("scars",1, tonumber(data.scars.scars_type), 0, 0, 1, 1.0,0, tonumber(0),0,0,0,tonumber(0), tonumber(data.scars.scars_visibility / 100), ped)
            Wait(50)
        end

        if (data.wrinkles ~= nil and data.wrinkles.wrinkles_type > 1) then
            toggleOverlayChange("ageing", 1, tonumber(data.wrinkles.wrinkles_type),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.wrinkles.wrinkles_visibility / 100), ped)
            Wait(50)
        end

        if (data.freckles ~= nil and data.freckles.freckles_type > 1) then
            toggleOverlayChange("freckles",1, tonumber(data.freckles.freckles_type),0, 0, 1, 1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.freckles.freckles_visibility / 100), ped)
            Wait(50)
        end

        if (data.moles ~= nil and data.moles.moles_type > 1) then
            toggleOverlayChange("moles",1, tonumber(data.moles.moles_type),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.moles.moles_visibility / 100), ped)
            Wait(50)
        end

        if (data.pears ~= nil and data.pears.pears_type > 1) then
            toggleOverlayChange("spots",1,tonumber(data.pears.pears_type),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.pears.pears_visibility / 100), ped)
            Wait(50)
        end

        if (data.eyeliner ~= nil and data.eyeliner.eyeliner_type > 1) then
            toggleOverlayChange("eyeliners",1, tonumber(1),0,0,0,1.0,0,tonumber(data.eyeliner.eyeliner_color_palette), tonumber(data.eyeliner.eyeliner_main_color), tonumber(data.eyeliner.eyeliner_second_color), tonumber(data.eyeliner.eyeliner_third_color),tonumber(data.eyeliner.eyeliner_type), tonumber(data.eyeliner.eyeliner_visibility / 100), ped)
            Wait(50)
        end

        if (data.shadows ~= nil and data.shadows.shadows_type > 1) then
            toggleOverlayChange("shadows",1, tonumber(1),0,0,0,1.0,0,tonumber(data.shadows.shadows_color_palette), tonumber(data.shadows.shadows_main_color), tonumber(data.shadows.shadows_second_color), tonumber(data.shadows.shadows_third_color),tonumber(data.shadows.shadows_type), tonumber(data.shadows.shadows_visibility / 100), ped)
            Wait(50)
        end

        if (data.lipsticks ~= nil and data.lipsticks.lipsticks_type > 1) then
            toggleOverlayChange("lipsticks",1, tonumber(1),0,0,0,1.0,0,tonumber(data.lipsticks.lipsticks_color_palette), tonumber(data.lipsticks.lipsticks_main_color), tonumber(data.lipsticks.lipsticks_second_color), tonumber(data.lipsticks.lipsticks_third_color),tonumber(data.lipsticks.lipsticks_type), tonumber(data.lipsticks.lipsticks_visibility / 100), ped)
            Wait(50)
        end

        if (data.blush ~= nil and data.blush.blush_type > 1) then
            toggleOverlayChange("blush",1, tonumber(data.blush.blush_type),0,0,0,1.0,0,tonumber(data.blush.blush_color_palette), tonumber(data.blush.blush_main_color), tonumber(data.blush.blush_second_color), tonumber(data.blush.blush_third_color),tonumber(0), tonumber(data.blush.blush_visibility / 100), ped)
        end
    end
end

exports('loadSkin', loadSkin)
exports('doesThisFixWorks', doesThisFixWorks)
exports('isPedUsingComponent', isPedUsingComponent)