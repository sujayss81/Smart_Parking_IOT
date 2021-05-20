const hw_debug = require("debug")("hardware");
var tcp = require("net");

const startTcpServer = () => {
  var tcp_server = tcp.createServer();

  tcp_server.on("connection", (con) => {
    console.log("NEW connection");
    global.tcpCon = con;

    con.setEncoding("utf8");

    con.on("close", (he) => {
      if (he) {
        console.log(he);
      }
      console.log("Connection closed");
      global.tcpCon = null;
    });

    con.on("error", (e) => {
      hw_debug(`Hardware Error\n${e}`);
    });
  });
  tcp_server.listen(process.env.TCP_PORT, () => {
    console.log(`TCP Server Started on port ${process.env.TCP_PORT}\n`);
  });
};

module.exports = { startTcpServer };
