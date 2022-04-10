local endpoint = "livemap-server.php"
local noplayers = false
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function SendNewData()
	local xPlayer = ESX.GetPlayerFromId(source)
    local data = {}
    local online = GetNumPlayers()
    deb("Trying to send data")

    if noplayers == true and online == 0 then
        deb("No players online")
        return
    end
	
	for _, player in pairs(ESX.GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(player)
		if Config.Jobs[xPlayer.job.name] then
			noplayers = false
			local coords = GetEntityCoords(GetPlayerPed(player))
			deb(coords)
			local name = GetPlayerName(player)
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
        if Config.Showuser(id) then
            i = i + 1
        end
    end
    return i
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