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
Config.PlayerInVehicle = true

-- Allowed Vehicle Hash
Config.AllowedVehicles = {
    [-1216765807] = true
}