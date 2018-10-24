const fs = require('fs')

console.time("read-async")
fs.readdir('../../testProgramm/node_modules', "utf-8", (err,data) => {
    if (err) throw err;
    console.log(data.toString());
})
console.timeEnd("read-async")