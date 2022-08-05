package packet.clientbound;

import haxe.io.BytesOutput;
import packet.serverbound.PingRequestPacket;

using VarIntLong;

class PingResponsePacket extends ClientboundPacket {
    public static function sendFromRequestPacket(client:Connection, req:PingRequestPacket) {
        trace('sending ping response');
        var bytes = new BytesOutput();
        bytes.writeVarInt(0x01);
        trace(req.payload.toHex());
        bytes.writeBytes(req.payload, 0, 8);
        var o = bytes.getBytes();
        client.output.writeVarInt(o.length);
        client.output.writeBytes(o, 0, o.length);
        client.output.flush();
    }
}