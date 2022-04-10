local endpoint = "livemap-server.php"
local noplayers = false
local playerinvehicle = {}
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function SendNewData()
    local data = {}
    local online = GetNumPlayers()
    deb("Trying to send data")

    if noplayers == true and online == 0 then
        deb("No players online")
        return
    end
	
	for k, v in pairs(ESX.GetPlayers()) do
		if Showuser(v) then
			noplayers = false
			local coords = GetEntityCoords(GetPlayerPed(v))
			deb(coords)
			local name = GetPlayerName(v)
			deb(name)
			local d = {}
			d["name"] = name
			d["location"] = coords
			table.insert(data, d)
		end
	end

    local senddata = {}
    senddata["data"] = data
    senddata["privkey"] = Config.PrivateKey
    local header = {}
    header["content-type"] = "application/x-www-form-urlencoded"
    deb("Sending request to VCAD")
    local time = os.time();
    PerformHttpRequest("https://livemap.vcad.li/"..endpoint, function (errorCode, resultData, resultHeaders)
        deb(errorCode)
        deb(resultData)
        deb(os.time() - time)
    end, 'POST', urlencode(json.encode(senddata)), header)

    if online == 0 then
        noplayers = true
    end
end


Citizen.CreateThread(function()
    while true do
        SendNewData()
        Citizen.Wait(1000 * Config.UpdateRate)
    end
end)

function GetNumPlayers()
    local i = 0
    for id, _ in ipairs(ESX.GetPlayers()) do
        if Showuser(id) then
            i = i + 1
        end
    end
    return i
end

function Showuser(id)
    local xPlayer = ESX.GetPlayerFromId(id)
    if Config.Jobs[xPlayer.job.name] ~= nil and Config.Jobs[xPlayer.job.name] then -- Check Job
        if Config.NeededItem == nil or 
        (Config.NeededItem ~= nil and xPlayer.getInventoryItem(Config.NeededItem).count > 0) then -- Check Item
            if not Config.PlayerInVehicle or (Config.PlayerInVehicle and playerinvehicle[id] ~= nil and 
            (Config.AllowedVehicles == nil or Config.AllowedVehicles[playerinvehicle[id]] == true)) then -- Check Vehicle
                return true
            end
        end
    end
    return false
end

function deb(msg)
    if Config.DebugMode then
        print(msg)
    end
end

function urlencode (str)
    str = string.gsub (str, "([^0-9a-zA-Z !'()*._~-])", -- locale independent
       function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
    return str
 end

 RegisterNetEvent("vcad-livemap:vehicle_entered")
 AddEventHandler("vcad-livemap:vehicle_entered", function(model)
    playerinvehicle[source] = model
 end)

 RegisterNetEvent("vcad-livemap:vehicle_left")
 AddEventHandler("vcad-livemap:vehicle_left", function()
    playerinvehicle[source] = nil
 end)