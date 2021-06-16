// require pegjs module
const peg = require("pegjs");
const fs = require("fs");
var http = require('http');

const PORT = 8080;

// read grammar
fs.readFile('./grammar.pegjs', (err, grammar) => {
    if (err) {
        throw err;
    }

    // create parser with given grammar
    const parser = peg.generate(grammar.toString());

    // read example parser input
    fs.readFile('./example_simple.txt', (err, input) => {
        if (err) {
            throw err;
        }
        // parse input
        const output = parser.parse(input.toString());

        // save output to 'output.html'
        fs.writeFile('output.html', output, (err) => {
            if (err) {
                throw err;
            }

            // simple http server returning parsed html page (default: localhost:8080)
            http.createServer((request, response) => {
                response.writeHeader(200, {"Content-Type": "text/html"});
                response.write(output);
                response.end();
            }).listen(PORT)
        })        
    })
})