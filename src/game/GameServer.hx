package game;

import sys.net.Host;
import sys.net.Socket;
import entity.Player;

class GameServer {
    public var players:Array<Player>;
    public var connections:Array<Connection>;
    var listeningSocket:Socket;

    public static final VERSION:VersionInfo = AllVersions.VERSION_1_19;

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
        listeningSocket.listen(100);
        while (true) {
            var client = listeningSocket.accept();
            if (client == null) continue;
            this.connections.push(new Connection(client));
        }
    }
}

class AllVersions {
    // TODO: finish adding in-between versions
    public static final VERSION_1_19_1 = {semver: '1.19.1', protocol: 760, name: 'The Wild Update'};
    public static final VERSION_1_19 = {semver: '1.19', protocol: 759, name: 'The Wild Update'};
    public static final VERSION_1_18_2 = {semver: '1.18.2', protocol: 758, name: 'Caves & Cliffs: Part 2'};
    public static final VERSION_1_18_1 = {semver: '1.18.1', protocol: 757, name: 'Caves & Cliffs: Part 2'};
    public static final VERSION_1_18 = {semver: '1.18', protocol: 757, name: 'Caves & Cliffs: Part 2'};
    public static final VERSION_1_17_1 = {semver: '1.17.1', protocol: 756, name: 'Caves & Cliffs: Part 1'};
    public static final VERSION_1_17 = {semver: '1.17', protocol: 755, name: 'Caves & Cliffs: Part 1'};
    public static final VERSION_1_16_5 = {semver: '1.16.5', protocol: 754, name: 'The Nether Update'};
    public static final VERSION_1_16_4 = {semver: '1.16.4', protocol: 754, name: 'The Nether Update'};
    public static final VERSION_1_16_3 = {semver: '1.16.3', protocol: 753, name: 'The Nether Update'};
    public static final VERSION_1_16_2 = {semver: '1.16.2', protocol: 751, name: 'The Nether Update'};
    public static final VERSION_1_16_1 = {semver: '1.16.1', protocol: 736, name: 'The Nether Update'};
    public static final VERSION_1_16 = {semver: '1.16', protocol: 735, name: 'The Nether Update'};
    public static final VERSION_1_15 = {semver: '1.15', protocol: 573, name: 'Buzzy Bees'};
    public static final VERSION_1_14 = {semver: '1.14', protocol: 477, name: 'Village & Pillage'};
    public static final VERSION_1_13 = {semver: '1.13', protocol: 393, name: 'Update Aquatic'};
    public static final VERSION_1_12 = {semver: '1.12', protocol: 335, name: 'World of Color'};
    public static final VERSION_1_11 = {semver: '1.11', protocol: 315, name: 'Exploration Update'};
    public static final VERSION_1_10 = {semver: '1.10', protocol: 210, name: 'Frostburn Update'};
    public static final VERSION_1_9 = {semver: '1.9', protocol: 107, name: 'Combat Update'};
    public static final VERSION_1_8 = {semver: '1.8', protocol: 47, name: 'Bountiful Update'};
    public static final VERSION_1_7_2 = {semver: '1.7.2', protocol: 4, name: 'The Update That Changed The World'};
    // versions older than this are pre-netty, and will not be supported ever probably.
}

typedef VersionInfo = {
    var semver:String;
    var protocol:Int;
    var name:String;
}