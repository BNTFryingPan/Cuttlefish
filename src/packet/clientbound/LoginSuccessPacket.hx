package packet.clientbound;

import haxe.io.Bytes;
using VarIntLong;

class LoginSuccessPacket extends ClientboundPacket {
    public function new() {
        super(0x02);
    }

    public function send(client:Connection, uuid:Bytes, name:String) {
        var out = this.beginSend(client);
        //uuid.writeToStream(out);
        out.write(uuid);
        out.writeVarString(name);
        out.writeVarInt(0);
        this.finishSend();
    }
}