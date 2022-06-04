Config = {}
Config.Enable = true
Config.DebugMode = false
Config.PrivateKey = ""

-- Update Rate in secs
Config.UpdateRate = 1

--[[
 System where the players should be shown

 - "copnet" - Only CopNet
 - "medicnet" - Only MedicNet
 - "carnet" - Only CarNet
 - "*" - All systems
]]
Config.System = "copnet"

--[[
Blipcolor

1 = white
2 = blue
3 = green
4 = red
5 = yellow
]]
Config.Color = 1

-- If player needs to be in an vehicle
Config.PlayerInVehicle = false

-- Allowed Vehicle Hash
Config.AllowedVehicles = {
    [-1216765807] = true
}

-- Enable /panic command
Config.CommandPanic = true
-- Enable /gps command
Config.CommandGPS = true


-- Should everyone get a notification if someone panics
Config.ShowPanicNotfication = true
