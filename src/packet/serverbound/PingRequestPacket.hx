package packet.serverbound;

import haxe.io.Bytes;
import haxe.io.Input;

class PingRequestPacket extends ServerboundPacket {
    public var payload:Bytes;

    public function new() {
        super(0x01);
    }

    public static function read(stream:Input):PingRequestPacket {
        var packet = new PingRequestPacket();
        trace('reading');
        packet.payload = stream.read(8);
        trace(packet.payload.toHex());
        trace('read');
        return packet;
    }
}