package packet.serverbound;

import haxe.io.Bytes;
import haxe.io.Input;

class ServerboundPacket {
    public var id(get,never):Int;
    private var _id:Int;

    public var extraData:Null<Bytes>;

    function get_id():Int {
        return this._id;
    }

    public function new(id:Int) {
        this._id = id;
        trace('C->S 0x${StringTools.hex(id)}');
    }

    public function handle(client:Connection) {}

    /**
        this function handles reading the length of an unknown packet type to
        effectively skip in, instead of just reading the next bytes as a packet
        id (which would likely also be an unknown packet) and causing a chain
        of unknown (or corrupt! if the data includes a byte that matches a
        known packet id) packets.
    **/
    public static function readUnknownPacket(input:Input, len:Int, id:Int):ServerboundPacket {
        var packet = new ServerboundPacket(id);
        packet.extraData = input.read(len);
        trace('unknown packet: $id');
        return packet;
    }
}