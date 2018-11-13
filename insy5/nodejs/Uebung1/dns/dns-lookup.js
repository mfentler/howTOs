var dns = require('dns');

if (process.argv.length > 2) {
    for (var i = 2; i < process.argv.length; i++) {
        let url = process.argv[i];
        dns.lookup(url, function (err, address) {
            if (err) console.log(err)   // Log errors
            else console.log(url + " : " + JSON.stringify(address))
        });
    }
} else {
    console.log("Give me some argggggs")
}