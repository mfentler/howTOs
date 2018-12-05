# __CRUD Webanwendung mittels express__
Autor: Mario Fentler  
Datum: 05.12.2018  

Für die Übung wurde ein Webserver mit Express erstellt. Auf dem kann man über ein Formular Schueler in eine MongoDb einfügen.
Required packages

    npm init
    npm install mongodb --save
    npm install express --save express
    npm install body-parser --save

In die Datei __index.ejs__ (ejs steht für extended JavaScript) wird der HTML Code der Webseite rein geschrieben. Auf der Webseite wird für die schönere Visualisierung das Bootstrap Framework verwendet.    
Es kann auch JavaScript Code, der __auf dem Server ausgeführt__ werden soll in dieses File eingefügt werden. Das macht man so:  

    <% for (var i = 0; i < schueler.length; ++i) { %>
    Mit den <%= %>

## __Aufgabendurchführung__
Als erster Schritt werden im js File Konstanten erstellt.  

    const express = require('express')
    const MongoClient = require('mongodb').MongoClient
    const mongoDB = require('mongodb')
    const app = express()

    //Damit ich die Formulare als JSON bekomme
    const bodyParser = require('body-parser')
    app.use(bodyParser.urlencoded({extended:false}))

### __MongoDB - mlab__
Als Datenbank wird mongoDB verwendet, welches über die Webseite von m-lab.com erreichbar ist. Dort erstellt man sich eine neue Datenbank und eine Collection.  

Anschließend kann man sich im Server über den MongoClient damit verbinden.  

    MongoClient.connect('mongodb://databaseUser:avHg6Ny4aAwXikpzde@ds113454.mlab.com:13454/5chit_insy', (err,databaseConnection)=>{
    if (err) {
        console.log('Fehler bei der Verbindung zur Datenbank')
        console.log(err)
    }else{
        db = databaseConnection.db('5chit_insy')
        app.listen(8080, ()=>{
            console.log('Server laeuft auf 127.0.01:8080')
        })
    }
})

### __Routing__
Im Server werden einzelnen Routen verschiedene Methoden zugewiesen. Die zum auslesen aller User, die standardmäßig über '/' aufgerufen wird könnte so aussehen:  

    app.get('/', (req,res)=>{
        db.collection('schueler').find().toArray((err,result)=>{
            if(err){
                console.log(err)
            }else{
                res.render('index.ejs', {schueler:result})
            }
        })
    })
Dabei wird über __db.collection(<collection-name\>).find().toArray() auf die Documente in der Datenbank zugegriffen und diese dann an die Webseite weitergeleitet.  
__toArray()__ wird verwendet, da es sich hier um mehere Ergebnisse handeln kann.

### __Anzeige auf der Webseite__
Die Webseite, in dem Fall index.ejs und edit.ejs(mehr zu dieser später) enthalten den HTML-Code der Webseite. Man kann auf der Webseite allerdings auch Code vom Server einbinden. Das funktioniert ähnlich wie mit Ajax.)

## Sources
https://stackoverflow.com/questions/4932928/remove-by-id-in-mongodb-console  
https://stackoverflow.com/questions/736590/add-new-attribute-element-to-json-object-using-javascript  
https://www.w3schools.com/tags/att_input_type_hidden.asp  
https://docs.mongodb.com/manual/reference/method/db.collection.updateOne/  
https://stackoverflow.com/questions/42396025/express-cannot-post-quotes  
https://mongodb.github.io/node-mongodb-native/markdown-docs/queries.html  
https://www.w3schools.com/jquery/jquery_get_started.asp
