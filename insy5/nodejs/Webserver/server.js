const http = require('http')
//URL Modul verwenden, da in der normalen URL Sonderzeichen enthalten sein können
const url = require('url')
const fs = require('fs')

http.createServer((request, response) => {
    let requestedPath = url.parse(request.url).pathname
    //process.cwd() gets me the current directory
    let searchPath = process.cwd() + requestedPath
    console.log(searchPath)

fs.readdir(searchPath, "utf-8", (err, allData) => {
    if(err) {
        response.writeHead(404, {'Content-Type': 'text/html'})
        response.write("File not found")
    }
    else{
        response.writeHead(200, {'Content-Type': 'text/html'})
    response.write('<h1>Required content of directory</h1><u>Open File in new Tab in Firefox. Dort refreshen, damit die Sachen angezeigt werden.</u></br>Ich weiss nicht warum der Link nicht geht.</br>')
allData.forEach(data => {
	let searchString = searchPath + data.toString() + '\\'
	searchString = searchString.replace('/','\\')
	
	let fileString = 'file:///' + searchString
    fileString = fileString.replace('C:\\','C:\\\\')
	
    response.write('<a href="'+ fileString +'">' + data.toString() + '</a></br>')
})
}
response.end()
})


}).
listen(8080)

console.log('Server läuft auf localhost:8080')