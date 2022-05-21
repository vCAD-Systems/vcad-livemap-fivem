# ESX

Die ESX-Version ist nur mit dem verbreiteten ESX-Legacy framework kompatibel
[Download hier](download)  

### Config
#### Erklärung

##### Config.Enable
Soll das Script aktiviert werden und Spielerpositionen an die LiveMap gesendet werden?
- Ja `true`
- Nein `false`


##### Config.DebugMode
Soll der Debugmode aktiviert werden? Dieser Modus gibt Diagnoseinformationen in der Serverkonsole aus.  
Für den Produktiv einsatz nicht geeignet.
- Ja `true`
- Nein `false`


##### Config.PrivateKey
Dieser Schlüssel identifiziert das Script bei CopNet. Du erhälst ihn im VCAD-System unter Einstellungen -> Livemap einstellungen
!> **Wichtig!** Halte diesen Schlüssel geheim, um Manipulation zu verhindern.
Der Text muss zwischen zwei Anführungszeichen `"` gesetzt werden.


##### Config.UpdateRate
Alle wie viele Sekunden aktuelle Informationen an den LiveMap Server gesendet werden sollen.  
Niedriger: Aktuellere Daten in der LiveMap
Höher: Weniger Serverlast, sowie Lag
Ganzzahlwert zwischen 0 und 60


##### Config.JobNeeded
Muss der Spieler einen spezifischen Job haben, um auf der LiveMap angezeigt zu werden?
- Ja `true`
- Nein `false`


##### Config.Jobs
Eine Lua-Tabelle, welche Jobs auf der LiveMap angezeigt werden sollen und in welcher Farbe.
```lua
["job"] = color
```
| **Farbe** | **Nummer** |
|-----------|------------|
| Weiß      | 1          |
| Blau      | 2          |
| Grün      | 3          |
| Rot       | 4          |
| Gelb      | 5          |


##### Config.NeededItem
Muss der Spieler ein Item im Inventar haben?
- Ja `Config.NeededItem = "ITEMNAME"`
- Nein `Config.NeededItem = null`


##### Config.PlayerInVehicle
Muss der Spieler in einem Fahrzeug sein, um auf der Livemap angezeigt zu werden?
- Ja `true`
- Nein `false`


##### Config.AllowedVehicles
Welche Fahrzeuge sind zugelassen?

```lua
[hash] = true
```


#### Datei
```lua
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
-- Enable /gps command
Config.CommandGPS = true


-- Use the ESX identity Ingame name
-- Only works if ESX identity is installed
Config.RPName = true


-- Should everyone with the same job get a notification if someone panics
Config.ShowPanicNotfication = true

```