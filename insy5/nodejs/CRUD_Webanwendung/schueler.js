const express = require('express')
const MongoClient = require('mongodb').MongoClient
const mongoDB = require('mongodb')
//Damit ich die Formulare als JSON bekomme
const bodyParser = require('body-parser')

const app = express()
//Damit ich die Formulare als JSON bekomme
app.use(bodyParser.urlencoded({extended:false}))

let db

app.get('/:class', (req,res) => {
    
})

app.get('/', (req,res)=>{
    db.collection('schueler').find().toArray((err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.render('index.ejs', {schueler:result})
        }
    })
})
app.get('/search/:class', (req,res) => {
	if(req.body.filterclass == "Alle" || res.body == null){
		db.collection('schueler').find().toArray((err,result)=>{
			if(err){
				console.log(err)
			}else{
				res.render('index.ejs', {schueler:result})
			}
		})
	}else{
		db.collection('schueler').find({"klasse":req.body.filterclass}).toArray((err,result) => {
			if(err){
				console.log(err)
			}else{
				res.render('index.ejs', {schueler:result})
			}
		})
	}
})

app.post('/search/:class', (req,res) => {
	if(req.body.filterclass == "Alle"){
		db.collection('schueler').find().toArray((err,result)=>{
			if(err){
				console.log(err)
			}else{
				res.render('index.ejs', {schueler:result})
			}
		})
	}else{
		db.collection('schueler').find({"klasse":req.body.filterclass}).toArray((err,result) => {
			if(err){
				console.log(err)
			}else{
				res.render('index.ejs', {schueler:result})
			}
		})
	}
})

app.post('/edit', (req,res)=>{
    db.collection('schueler').find({_id: mongoDB.ObjectID(req.body.id)}).toArray((err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.render('edit.ejs', {schueler:result[0]})
        }
    })
})

app.post('/edit/:status', (req,res)=>{
    db.collection('schueler').updateOne({_id: mongoDB.ObjectID(req.body.id)},{$set: {"vorname":req.body.vorname,"nachname":req.body.nachname,"lieblingsfach":req.body.lieblingsfach,"klasse":req.body.klasse}}, (err,result)=>{
        if(err){
            console.log(err)
        }else{
            console.log('Update successfull ..\nredirecting ..')

            res.redirect('/')
        }
    })
})



app.post('/delete', (req,res)=>{
    console.log(req.body.id)
    db.collection('schueler').deleteOne( { _id: mongoDB.ObjectID(req.body.id)}, (err,result)=>{
        if(err){
            console.log(err)
        }else{
            console.log('User geloescht')
            res.redirect('/')
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

