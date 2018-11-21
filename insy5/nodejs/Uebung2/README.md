# Websockets mit express
Für die Übung wurde ein Webserver mit Express erstellt. Auf dem kann man über ein Formular Schueler in eine MongoDb einfügen.
Required packages

    npm install --save mongodb
    npm install --save express
    npm install --save body-parser

In die Datei __index.ejs__ (ejs steht für extended JavaScript) wird der HTML Code rein geschrieben.  
Man kann auch JavaScript Code, der __auf dem Server ausgeführt__ werden soll hinschreiben. Das macht man so:  

    <% for (var i = 0; i < %>