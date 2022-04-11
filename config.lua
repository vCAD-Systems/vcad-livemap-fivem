Config = {}
Config.Enable = true
Config.DebugMode = true
Config.PrivateKey = "yT8kmhcdfOMrF3e"

-- Update Rate in secs
Config.UpdateRate = 1

-- If you need a specific job to be shown
Config.JobNeeded = true


--[[
Allowed jobs and the assigned blipcolor
["job"] = color

1 = white
2 = blue
3 = green
4 = red
5 = yellow
]]
Config.Jobs = {
    ['police'] = 2,
    ['fib'] = 1,
    ['ambulance'] = 4,
    ['mechanic'] = 5
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

-- Use the ESX identity Ingame name
-- Only works if ESX identity is installed
Config.RPName = true