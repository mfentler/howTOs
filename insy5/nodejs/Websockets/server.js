const exp = require('express')
const app = exp()
const http = require('http').Server(app)
const io = require ('socket.io')(http)


app.get('/', (request,response) =>{
    response.sendFile(__dirname + '/index.html')
})

io.on('connection',(socket) => {
    console.log('Neuer Client verbunden!')
    socket.on('chat message', (msg) => {
        console.log('Neue Nachricht: ' + msg)
    })
})

http.listen(8080, (err,data) =>{
    console.log('Server läuft auf 127.0.0.1:8080')
})
