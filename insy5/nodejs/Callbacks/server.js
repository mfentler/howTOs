const http = require('http')
//URL Modul verwenden, da in der normalen URL Sonderzeichen enthalten sein können
const url = require('url')
const fs = require('fs')

http.createServer((request,response) => {
    let requestedPath = url.parse(request.url).pathname
    //process.cwd() gets me the current directory
    let searchPath = process.cwd()+requestedPath
    console.log(searchPath)

    fs.readdir(searchPath, "utf-8", (err,allData) => {
        if (err){ 
            response.writeHead(404,{'Content-Type':'text/html'})
            response.write("File not found")
        }
        else{
            response.writeHead(200,{'Content-Type':'text/html'})
            response.write('<h1>Required content of directory</h1>')
            allData.forEach(data =>{
                response.write('<a href=/'+searchPath+'/'+data.toString()+'\'>'+data.toString()+'</a></br>')
            })
        }
        response.end()
    })
    

}).listen(8080)

console.log('Server läuft auf localhost:8080')