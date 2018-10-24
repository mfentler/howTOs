const fs = require('fs')

console.time("read-async")
fs.readdir('../node_modules', "utf-8", (err,data) => {
    if (err) console.log(err)
    else console.log(data.toString());
})
console.timeEnd("read-async")