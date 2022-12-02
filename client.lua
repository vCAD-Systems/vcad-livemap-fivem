local isinveh = false
local vehicle = nil
local type = ""
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()

        if not isinveh and IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetEntityModel(GetVehiclePedIsIn(playerPed, false))
            isinveh = true
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
        elseif isinveh then
            isinveh = false
            vehicle = nil
            TriggerServerEvent("vcad-livemap:vehicle_left")
        end

        Citizen.Wait(1000)
    end
end)