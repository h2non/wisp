// Generated by LispyScript v0.1.0
null;
(function(){
    var http = require("http");
    var server = http.createServer(function(request,response){
        response.writeHead(200,{'Content-Type': 'text/plain'});
        return response.end("Hello World\n");
    });
    server.listen(1337,"127.0.0.1");
    return console.log((function(){
        return (Array.prototype.slice.call(arguments)).join("");
    })("Server running at http://","127.0.0.1",":",1337,"/"));
})();
