local isinveh = false
local vehicle = nil
Citizen.CreateThread(function()

    while true do

        if IsPedInAnyVehicle(PlayerPedId(), false) then
            if not isinveh then
                isinveh = true
                vehicle = GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                TriggerServerEvent("vcad-livemap:vehicle_entered", vehicle)
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