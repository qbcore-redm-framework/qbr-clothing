function loadClothes(ped, data, preview)
    if data and next(data) then
        while not Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, ped) do
            Wait(1)
        end
        local sex = IsPedMale(ped) and 'Male' or 'Female'
        for k,v in pairs(data) do
            for n,j in pairs(Clothes[sex]) do
                if (k == n) then
                    if (v > 0) then
                        Citizen.InvokeNative(0xD710A5007C2AC539, ped, GetHashKey(k), 0)
                        if (k == 'shirts_full') then
                            Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, tonumber(TorsoComponent), false, true, true)
                        elseif (k == 'boots' or k == 'pants') then
                            Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, tonumber(TorsoComponent), false, true, true)
                        end
                        local hash = Clothes[sex][k][v]
                        Citizen.InvokeNative(0xD3A7B003ED343FD9, ped,  tonumber(hash), false, true, true)
                    else
                        Citizen.InvokeNative(0xD710A5007C2AC539, ped, GetHashKey(k), 0)
                    end
                end
            end
        end
        Citizen.InvokeNative(0x704C908E9C405136, ped)
        Citizen.InvokeNative(0xAAB86462966168CE, ped, 1)
        Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, 0, 1, 1, 1, 0)
        if not preview then
            ClothesData = data
        else
            PreviewClothesData = data
        end
    else
        if not preview then
            ClothesData = {}
        else
            PreviewClothesData = {}
        end
    end
end


exports('loadClothes', loadClothes)