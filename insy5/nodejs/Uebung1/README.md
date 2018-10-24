Mario Fentler  
24.10.2018
# Protokoll - Übung 1

## Aufgabenstellung:  
- Schreibe ein Programm, das zu Domains mittels eines DNS lookups die ip-Adresse(n) ermitteln und ausgeben kann. Die Domains (beliebig viele) sollen dabei als Kommandozeilenargument angegeben werden können. (Hint: Den Inhalt von process.argv anschauen).
- Schreibe zwei Programme die alle Dateien in einem gegebenen Verzeichnis synchronbzw. asychron auslesen und ausgeben (siehe fs.readdir()). Im ersten Fall sollen mit dem Einlesen einer Datei erst begonnen werden, wenn die Ausgabe der vorigen Datei fertig ist, im zweiten Fall soll dies parallel geschehen. Welches der beiden Programme ist performanter?

## Aufgabendurchführung
Die geschriebenen Programme werden über die Console mit folgenden Befehlen aufgerufen:  

    node dns-lookup.js mario.fentler.com tgm.ac.at google.at

    node read-sync.js
    node read-async.js

### Aufgabe 1 - DNS Lookup
Für das Programm wird das Node-Modul "dns" benötigt.  
Die Kommandozeilen Argumente kann man mit "__process.argv[i]__" ansprechen. 

Hier in dem Beispiel wird zuerst abgefragt ob es mehr als 2 Args gibt (Wieso, wird beim Aufruf der Datei ersichtlich).  
Anschließend muss man einfach nur noch die Funktion "__dns.lookup(url)__" verwenden. Da ich will, dass das ganze asynchron abläuft wird auch ein __Callback__ eingesetzt.  
Die Funktion gibt dann einfach nur die URL mit der dazugehörigen IP-Adresse in der Console aus.

"Das Schlüsselwort __let__ deklariert eine Variable im Gültigkeitsbereich des lokalen Blocks. Optional wird die Variable mit einem Wert initialisiert."[1]

    //required Nodemodule
    var dns = require('dns');

    if(process.argv.length > 2){
        for(var i = 2; i < process.argv.length; i++){
            //let is a javascript 
            let url = process.argv[i];
            dns.lookup(url, function (err, address) {
                if (err) console.log(err)   // Log errors
                else console.log(url + " : " + JSON.stringify(address))
            });
        }
    }else{
        console.log("Give me some argggggs")
    }

### Aufgabe 2
#### Aufgabe 2a - Synchrones Dateiauslesen
In diesem File werden synchron die Dateien aus dem node_modules Ordner ausgelesen und auf die Console ausgegeben. Dabei wird jede Datei nacheinander abgearbeitet.

    const fs = require('fs')

    console.time("read-sync")
    var contents = fs.readdirSync('../node_modules', 'utf8');
    console.log(contents);
    console.timeEnd("read-sync")

#### Aufgabe 2b - Asynchrones Dateiauslesen
In diesem File werden die Dateien asynchron aus dem Ordner ausgelesen. Dadurch können diese Tasks parallel arbeiten und sind daher schneller.

    const fs = require('fs')

    console.time("read-async")
    fs.readdir('../node_modules', "utf-8", (err,data) => {
        if (err) throw err;
        console.log(data.toString());
    })
    console.timeEnd("read-async")

#### Geschwindigkeitsvergleich synchron vs asynchron
Mit den Commands "console.time()" und "console.endTime()" kann die Zeit gemessen werden.  

Demnach haben sich folgende Zeiten ergeben:  
- synchron:  
-> durchschnittlich __6ms__
- asynchron:  
-> durchschnittlich __1ms__

## Quellen
[1] https://developer.mozilla.org/de/docs/Web/JavaScript/Reference/Statements/let  
[2] https://nodejs.org/api/index.html  