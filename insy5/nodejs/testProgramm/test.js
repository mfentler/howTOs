console.log("Hello World")

var arr = [1,2,3,4]

for(var a of arr){
	console.log(a)
}

//Verschiedene Funktionsdefinitionen
function add5(x){
	return x+5
}

var add10 = function(x){
	return x+10
}

var add15 = (x) => {
	return x+15
}

function execute(fun, wert){
	console.log("Ergebnis:"+fun(wert))
}

execute(add5,42)

//Package für filesystem
//require lädt Library und weist sie dann einer Variable zu
const fs = require("fs")

fs.readFile('Hello.txt', (err,data) => {
	console.log(data.toString())
})