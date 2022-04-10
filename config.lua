Config = {}
Config.Enable = true
Config.DebugMode = true
Config.PrivateKey = "EcWo5PO3VZnH2mB"

-- Update Rate in secs
Config.UpdateRate = 1

-- Argument source is the players server id
Config.Showuser = function(source)
    return true
end

Config.Jobs = {
    ['police'] = true,
    ['fib'] = true
}