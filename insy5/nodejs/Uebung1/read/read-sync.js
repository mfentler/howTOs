const fs = require('fs')

console.time("read-sync")
var contents = fs.readdirSync('../../testProgramm/node_modules', 'utf8');
console.log(contents);
console.timeEnd("read-sync")