const cp = require('child_process')
//Führt das File in einem anderen Thread aus, blockiert aber nicht.
let task = cp.fork('slave.js')

console.log('master')

task.on('close',(code)=>{
    console.log('Ergebnis: '+code)
})