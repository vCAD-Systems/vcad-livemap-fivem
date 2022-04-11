Config = {}
Config.Enable = true
Config.DebugMode = true
Config.PrivateKey = "EcWo5PO3VZnH2mB"

-- Update Rate in secs
Config.UpdateRate = 1


Config.Jobs = {
    ['police'] = true,
    ['fib'] = true
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