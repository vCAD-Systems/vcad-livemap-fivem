local version = 1
local startup = false
local failed = false
local endpoint = "livemap-server.php"
local noplayers = false
local playerinvehicle = {}
local panicplayers = {}
local playeruntrackable = {}
local QBCore = exports['qb-core']:GetCoreObject()

-- Sends data to VCAD server
function SendNewData()
    local data = {}
    local online = GetNumPlayers()
    deb("Trying to send data - " ..online)

    -- Stops when nothing has changed since last time
    if noplayers == true and online == 0 then
        deb("No players online")
        return
    end
	
	for v, _ in pairs(QBCore.Functions.GetQBPlayers()) do
		if Showuser(v) then
			noplayers = false
			local coords = GetEntityCoords(GetPlayerPed(v))
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
        local player = QBCore.Functions.GetPlayer(player)
        return player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
    else
        return GetPlayerName(player)
    end
end

-- Internal
-- Counts players relevant for the livemap
-- used in checking if update is needed
function GetNumPlayers()
    local i = 0
    for v, _ in pairs(QBCore.Functions.GetQBPlayers()) do
        if Showuser(v) then
            i = i + 1
        end
    end
    return i
end

-- If the user shows up on the map
function Showuser(id)
    if playeruntrackable[id] ~= nil and playeruntrackable[id] then
        deb("untrackable")
        return false
    end 

    local player = QBCore.Functions.GetPlayer(id)
    if not Config.JobNeeded or (Config.Jobs[player.PlayerData.job.name] ~= nil and Config.Jobs[player.PlayerData.job.name] > -1) then -- Check Job
        if Config.NeededItem == nil or 
        (Config.NeededItem ~= nil and player.Functions.GetItemByName(Config.NeededItem) ~= nil) then -- Check Item
            if not Config.PlayerInVehicle or (Config.PlayerInVehicle and playerinvehicle[id] ~= nil and 
            (Config.AllowedVehicles == nil or Config.AllowedVehicles[playerinvehicle[id]["model"]] == true)) then -- Check Vehicle
                deb("Vehicle good - true")
                return true
            end
        end
    end
    deb("dont show user")
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
    local player = QBCore.Functions.GetPlayer(source)
    local style = {}
    local icon = 0
    local panic = ""
    if Config.Jobs[player.PlayerData.job.name] ~= nil then
        icon = Config.Jobs[player.PlayerData.job.name]
    end
    if playerinvehicle[source] ~= nil then
        if playerinvehicle[source]["type"] == "car" then
            icon = icon + 10
        end
        if playerinvehicle[source]["type"] == "aircraft" then
            icon = icon + 20
        end
        if playerinvehicle[source]["type"] == "heli" then
            icon = icon + 30
        end
    end
    if panicplayers[source] ~= nil and panicplayers[source] then 
        icon = -1 -- Panic blip
        panic = "<bold><span style='color: red;'>PANIC</span></bold>  "
    end
    style["icon"] = icon
    style["subtext"] = panic .. player.PlayerData.job.label .. " - " .. player.PlayerData.job.grade.name -- Text shown below the name of the player in the popup
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
AddEventHandler("vcad-livemap:vehicle_entered", function(model,type)
    playerinvehicle[source] = {}
    playerinvehicle[source]["model"] = model
    playerinvehicle[source]["type"] = type
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

    if state and Config.ShowPanicNotfication then
        for k,_  in pairs(QBCore.Functions.GetQBPlayers()) do
            if k ~= source then
                --TODO: Add Notification
                --local player = ESX.GetPlayerFromId(k)
                --xPlayer.showNotification("~r~Ein Panicbutten wurde gedrückt", false, true, 90)
            end
        end
    end
end)


function PerformVersionCheck()

    PerformHttpRequest("https://livemap.vcad.li/version.php?type=qbcore&version="..version, function (errorCode, resultData, resultHeaders)
        deb(errorCode)
        deb(resultData)
        local data = json.decode(resultData)

        local current = data.current
        local minimum = data.minimum
        local updatelink = data.link
        local message = data.message
        local changelog = data.changelog
        if version == current then
            startup = true
            print("Gestartet. Version aktuell")
        else
            if version >= minimum then
                startup = true
                print("Eine neue Version ist verfügbar. Bitte aktualisiere das Script. Link zur aktuellen Version:")
                print(updatelink)
            else
                print("Eine neue Version ist verfügbar. Diese Version ist nicht mehr kompatibel. Das Script wird sich deaktivieren. Um die LiveMap weiter zu nutzen, aktualisiere das Script.")
                print("Link zur aktuellen Version: "..updatelink)
                failed = true
            end
            if #changelog > 0 then
                print("Changelog:")
                for key,value in pairs(changelog) do
                    print("Version "..value["version"].. ": ".. value["text"])
                end
                
            end
        end
        if message ~= nil and message ~= "" then
            print(message)
        end
    end)

end


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

-- Adds /gps command if enabled in config
-- Use `/gps on` to enable gps [default]
-- Use `/gps off` to disable gps
if Config.CommandGPS then
    RegisterCommand("gps", function(source, args, raw) 
        
        if args[1] ~= nil then
            if args[1] == "on" then
                playeruntrackable[source] = false
            elseif args[1] == "off" then
                playeruntrackable[source] = true
            end
        end
    end, false)
end

Citizen.CreateThread(function()
    PerformVersionCheck()
    Citizen.Wait(1000)
    while true do
        if failed then
            break
        end
        if Config.Enable and startup then
            SendNewData()
        end        
        Citizen.Wait(1000 * Config.UpdateRate)
    end
end)

function tprint (tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
      formatting = string.rep("  ", indent) .. k .. ": "
      if type(v) == "table" then
        print(formatting)
        tprint(v, indent+1)
      elseif type(v) == 'boolean' then
        print(formatting .. tostring(v))      
      else
        print(formatting .. v)
      end
    end
  end