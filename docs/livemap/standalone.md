# Standalone

Die Standalone version ist mit allen FiveM-Frameworks kompatibel.
[Download hier](download)  

### Installation
Das Skript kann ganz einfach in den `resources` Ordner entpackt werden.  
Denke daran, es in der server.cfg einzutragen. 


### Events
Das Skript stellt einige Schnittstellen zur verfügung, welche von anderen Skripten verwendet werden können  
Alle Events sind server-seitig, müssen aber vom Client aus angestoßen werden.

##### vcad-livemap:panic
Setzt den Panikmodus.
- Aktiv `true`
- Inaktiv `false`
```lua
TriggerServerEvent("vcad-livemap:panic", true)
```


##### vcad-livemap:disablegps
Deaktiviert das GPS eines Spielers.
- Deaktiviert `true`
- Aktiviert `false`
```lua
TriggerServerEvent("vcad-livemap:disablegps", true)
```
