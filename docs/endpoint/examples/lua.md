# Lua Implementation für livemap-server.php
!> Nur eine beispielhafte Implementierung. Muss auf individuelle Fälle angepasst werden
```lua
local data = {}
data["privkey"] = "PRIVATE-KEY"
data["data"] = {}

-- Es können natürlich mehrere Spieler mitgesendet werden.
-- Dafür diesen Teil in einem Loop ausführen.
local player = {}
player["name"] = "Name des Spielers"
player["location"] = {"x":0,"y":0,"z":0}
player["style"] = {"icon": 1, "subtext": "Text im Popup"}
table.insert(data, player)

-- HTTP Header
local header = {}
header["content-type"] = "application/x-www-form-urlencoded"

-- Anfrage
-- WICHTIG: PerformHttpRequest ist eine FiveM Native funktion.
-- Sollte dieses Code-Beispiel außerhalb von FiveM eingesetzt werden, muss eine
-- passende Funktion des verwendeten Frameworks eingesetzt werden.
PerformHttpRequest("https://livemap.vcad.li/livemap-server.php", function (errorCode, resultData, resultHeaders)
    print(errorCode)
    print(resultData)
end, 'POST', urlencode(json.encode(data)), header)


-- Hilfsmethode:
-- Quelle: http://tutorialspots.com/lua-urlencode-and-urldecode-5528.html
function urlencode (str)
    str = string.gsub (str, "([^0-9a-zA-Z !'()*._~-])", -- locale independent
       function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
    return str
end
```