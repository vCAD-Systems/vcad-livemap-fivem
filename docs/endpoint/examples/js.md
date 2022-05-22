# Javascript implementation für livemap-server.php
!> Nur eine beispielhafte Implementierung. Muss auf individuelle Fälle angepasst werden
```js
let data = {};
data["privkey"] = "PRIVATE-KEY";
data["data"] = []


let player = {
    "name": "Name des Spielers",
    "location": {"x":0,"y":0,"z":0},
    "style": {"icon": 1, "subtext": "Text im Popup"}
}
data["data"].push(player)
const header = {"content-type": "application/x-www-form-urlencoded"}

// Wenn NodeJS verwendet wird:
const axios = require('axios');
axios.post('https://livemap.vcad.li/livemap-server.php', data, {"headers": header, data: JSON.stringify(data)})
    .then((res) => {
        console.log(`Status: ${res.status}`);
        console.log('Body: ', res.data);
    }).catch((err) => {
        console.error(err);
    });


// Wenn eine Browser-Umgebung verwendet wird:
var xhr = new XMLHttpRequest();
xhr.open("POST", "https://livemap.vcad.li/livemap-server.php", true);
xhr.setRequestHeader('Content-Type', 'application/json');
xhr.send(JSON.stringify(data));
```