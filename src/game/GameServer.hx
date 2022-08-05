package game;

import sys.net.Host;
import sys.net.Socket;
import entity.Player;

class GameServer {
    public var players:Array<Player>;
    public var connections:Array<Connection>;
    var listeningSocket:Socket;

    public function new(port:Int) {
        if (port > 65535) {
            throw 'invalid port';
        }
        if (port < 1) {
            throw 'invalid port';
        }

        this.players = [];
        this.connections = [];

        this.listeningSocket = new Socket();
        this.listeningSocket.bind(new Host('0.0.0.0'), port);
    }

    public function run() {
        while (true) {
            listeningSocket.listen(1);
            var client = listeningSocket.accept();
            if (client == null) continue;
            this.connections.push(new Connection(client));
        }
    }
}