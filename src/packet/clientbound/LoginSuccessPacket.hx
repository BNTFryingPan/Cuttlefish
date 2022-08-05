package packet.clientbound;

using VarIntLong;

class LoginSuccessPacket extends ClientboundPacket {
    override function get_id():Int {
        return 0x01;
    }

    public function new() {
        super();
    }

    public function send(client:Connection, uuid:UUID, name:String) {
        var out = this.beginSend(client);
        uuid.writeToStream(out);
        out.writeVarString(name);
        out.writeVarInt(0);
        this.finishSend();
    }
}