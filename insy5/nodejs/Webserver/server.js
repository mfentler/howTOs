const http = require('http')
//URL Modul verwenden, da in der normalen URL Sonderzeichen enthalten sein können
const url = require('url')
const fs = require('fs')

http.createServer((request, response) => {
    let requestedPath = url.parse(request.url).pathname
    //process.cwd() gets me the current directory
    let searchPath = process.cwd() + requestedPath

	fs.readdir(searchPath, "utf-8", (err, allData) => {
		if(err) {
			fs.readFile(searchPath, "utf-8",(err,fileStr) =>{
				if(err){
					response.writeHead(404, {'Content-Type': 'text/html'})
					response.write("File not found " + err)
				}else{
					response.writeHead(200, {'Content-Type': 'text/html'})
					response.write('<h1>Content of file</h1>')
					response.write(fileStr, function(err){response.end()})
				}
			})
		}
		else{
			response.writeHead(200, {'Content-Type': 'text/html'})
			response.write('<h1>Required content of directory</h1>')
			
			allData.forEach(data => {
				//Prints links to the webpage
				response.write('<a href="http://localhost:8080'+ requestedPath +'/'+ data +'">' + data + '</a></br>', function(err){response.end()})
			})
		}
	})
}).
listen(8080)

console.log('Server läuft auf localhost:8080')