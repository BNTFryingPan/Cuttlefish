package;

import game.GameServer;

using VarIntLong;

class Main {
    public static var server:GameServer;

    public static function main() {
        trace('starting game server');

        Main.server = new GameServer(25565);
        Main.server.run();
    }
}