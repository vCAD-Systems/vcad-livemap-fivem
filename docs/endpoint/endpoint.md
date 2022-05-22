# HTTP Endpoint

Um Daten an die Livemap zu senden, kann ein HTTP-Endpoint aufgerufen werden.


## livemap-server.php
#### Anfrage
`POST https://livemap.vcad.li/livemap-server.php`
#### Header
```
Content-Type: application/x-www-form-urlencoded
```

#### Daten
Die Daten müssen folgende Struktur haben:

```json
{
    "privkey": "Private-Key"
    "data": [
        "name": "Name des Spielers",
        "location": {
            "x":0,
            "y":0,
            "z":0
        },
        "style": {
            "icon": 1,
            "subtext": "Text der im Popup angezeigt wird."
        }
    ]
}

```
!> **Wichtig** Dieses JSON-Objekt muss urlencoded werden und als Body in der Anfrage mitgesendet werden
#### Icons
Referenz zu den IconIDs [hier](endpoint/icons)

#### Beispiele:
Beispiele sind hier zu finden:  
[Lua](endpoint/examples/lua.md)  
[Javascript](endpoint/examples/js.md)