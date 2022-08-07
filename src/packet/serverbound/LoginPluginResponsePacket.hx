package packet.serverbound;

class LoginPluginResponsePacket extends ServerboundPacket {
    public function new() {
        super(0x00);
    }
}