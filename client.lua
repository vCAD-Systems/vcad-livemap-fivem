local isinveh = false
local vehicle = nil
local type = ""
Citizen.CreateThread(function()

    while true do

        if IsPedInAnyVehicle(PlayerPedId(), false) then
            if not isinveh then
                isinveh = true
                vehicle = GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                type = ""
                if IsThisModelACar(vehicle) then
                    type = "car"
                end
                if IsThisModelAHeli(vehicle) then
                    type = "heli"
                end
                if IsThisModelAPlane(vehicle) then
                    type = "aircraft"
                end
                TriggerServerEvent("vcad-livemap:vehicle_entered", vehicle, type)
            end 
        else
            if isinveh then
                isinveh = false
                vehicle = nil
                TriggerServerEvent("vcad-livemap:vehicle_left")
            end
        end

        Citizen.Wait(1000)

    end
end)