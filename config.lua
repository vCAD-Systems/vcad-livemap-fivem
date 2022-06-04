Config = {}
Config.Enable = true
Config.DebugMode = false
Config.PrivateKey = ""

-- Update Rate in secs
Config.UpdateRate = 1

-- If you need a specific job to be shown
Config.JobNeeded = true


--[[
Allowed jobs and the assigned blipcolor
color:
1 = white
2 = blue
3 = green
4 = red
5 = yellow

systems:
- copnet
- medicnet
- carnet
- * (All Systems)
]]
Config.Jobs = {
    ['police'] =    {['color'] = 2, ['system'] = "copnet"},
    ['ambulance'] = {['color'] = 4, ['system'] = "medicnet"},
    ['mechanic'] =  {['color'] = 5, ['system'] = "carnet"}
}

-- If item is needed in Inventory
-- "item name" or nil
Config.NeededItem = nil

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


-- Use the RP Name of the Character
Config.RPName = true


-- Should everyone with the same job get a notification if someone panics
Config.ShowPanicNotfication = true