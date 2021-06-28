const http = require('http');
const fs = require('fs');
const url = require('url');

const requestListener = function (req, res) {
    const path = url.parse(req.url).pathname;

    switch (path) {
        case '/':
            res.writeHead(200, {
                'Content-Type': 'text/plain'
            });
            res.write("This is Test Message.");
            res.end();
            break;

        case '/favicon.ico':
            fs.readFile(__dirname + path, function (error, data) {
                if (error) {
                    res.writeHead(404);
                    res.write(error);
                    res.end();
                } else {
                    res.writeHead(200, {
                        'Content-Type': 'image/ico'
                    });
                    res.write(data);
                    res.end();
                }
            });
            break

        case '/example1.rss':
            fs.readFile(__dirname + path, function (error, data) {
                if (error) {
                    res.writeHead(404);
                    res.write(error);
                    res.end();
                } else {
                    res.writeHead(200, {
                        'Content-Type': 'application/rss+xml'
                    });
                    res.write(data);
                    res.end();
                }
            });
            break

        default:
            res.writeHead(404);
            res.write("opps this doesn't exist - 404");
            res.end();
            break;
    }
}

const server = http.createServer(requestListener);
server.listen(8080);
