const express = require('express')
const MongoClient = require('mongodb').MongoClient
//Damit ich die Formulare als JSON bekomme
const bodyParser = require('body-parser')

const app = express()
//Damit ich die Formulare als JSON bekomme
app.use(bodyParser.urlencoded({extended:false}))

let db

app.get('/', (req,res)=>{
    db.collection('schueler').find().toArray((err,result)=>{
        if(err){
            console.log(err)
        }else{
            console.log(result)
            res.render('index.ejs', {schueler:result})
        }
    })
})

app.post('/new', (req,res)=>{
    db.collection('schueler').insertOne(req.body, (err, result) =>{
        if(err){
            console.log('Fehler beim Speichern vom Schueler: ')
            console.log(err)
        }else{
            console.log('User gespeichert')
            res.redirect('/')
        }
    })
})

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

