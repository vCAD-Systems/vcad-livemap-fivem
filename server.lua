local endpoint = "livemap-server.php"
local noplayers = false
local playerinvehicle = {}
local panicplayers = {}
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


-- Sends data to VCAD server

function SendNewData()
    local data = {}
    local online = GetNumPlayers()
    deb("Trying to send data")

    -- Stops when nothing has changed since last time
    if noplayers == true and online == 0 then
        deb("No players online")
        return
    end
	
	for k, v in pairs(ESX.GetPlayers()) do
		if Showuser(v) then
			noplayers = false
			local coords = GetEntityCoords(GetPlayerPed(v)) -- Needs Onesync enabled to work
			deb(coords)
			local name = GetDisplayName(v)
			deb(name)
			local d = {}
			d["name"] = name
			d["location"] = coords
            d["style"] = GetStyle(v)
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

-- Internal
-- Names that gets displayed on the map
function GetDisplayName(player)
    if Config.RPName then
        local xPlayer = ESX.GetPlayerFromId(player)
        return xPlayer.getName()
    else
        return GetPlayerName(player)
    end
end

-- Internal
-- Counts players relevant for the livemap
-- used in checking if update is needed
function GetNumPlayers()
    local i = 0
    for id, _ in ipairs(ESX.GetPlayers()) do
        if Showuser(id) then
            i = i + 1
        end
    end
    return i
end

-- If the user shows up on the map
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

--[[
Returns table with style information for the icon on the map

"subtext": Text shown when clicked on icon

Reference for "icon":
icons[1] = "white";
icons[2] = "blue";
icons[3] = "green";
icons[4] = "red";
icons[5] = "yellow";
icons[6] = "alert"; Blinking blip

]]
function GetStyle(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local style = {}
    local icon = 0
    if panicplayers[source] ~= nil and panicplayers[source] then 
        icon = 6
    else
        icon = 1
    end
    style["icon"] = icon
    style["subtext"] = xPlayer.job.label .. " - " .. xPlayer.job.grade_label -- Text shown below the name of the player in the popup
    return style
end

-- Gets called when update to panic state is recieved via event or via command
function panic(source, state)
    panicplayers[source] = state
end

-- Debug Messages if Debug is enabled in config
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

-- Internal Event
-- Player entered Vehicle
RegisterNetEvent("vcad-livemap:vehicle_entered")
AddEventHandler("vcad-livemap:vehicle_entered", function(model)
    playerinvehicle[source] = model
end)

-- Internal Event
-- Player left Vehicle
RegisterNetEvent("vcad-livemap:vehicle_left")
AddEventHandler("vcad-livemap:vehicle_left", function()
    playerinvehicle[source] = nil
end)

-- External Event
-- To be triggert by external panic script
-- state: if panic for this player is enabled or disabled
RegisterNetEvent("vcad-livemap:panic")
AddEventHandler("vcad-livemap:panic", function(state)
    panic(source, state)
end)

-- Adds the /panic command if enabled in config
-- Use `/panic` to raise the alarm
-- Use `/panic reset` to reset the alarm
if Config.CommandPanic then
    RegisterCommand("panic", function(source, args, raw) 
        local p = true
        if args[1] ~= nil and args[1] == "reset" then
            p = false
        end
        panic(source, p)
    end, false)
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        SendNewData()
        Citizen.Wait(1000 * Config.UpdateRate)
    end
end)



