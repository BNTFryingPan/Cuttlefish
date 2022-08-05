package packet.serverbound;

import haxe.io.Input;

class StatusRequestPacket extends ServerboundPacket {
    public function new() {
        super(0x00);
    }

    public static function read(stream:Input):StatusRequestPacket {
        var packet = new StatusRequestPacket();
        return packet;
    }
}