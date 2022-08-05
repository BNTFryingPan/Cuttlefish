package packet.clientbound;

import haxe.io.BytesOutput;
using VarIntLong;

class ClientboundPacket {
    public var id(get,never):Int;
    var sendingBytes:Null<BytesOutput>;
    var sendingTo:Null<Connection>;

    function get_id():Int {
        return -1;
    }

    public function new() {

    }

    function beginSend(client:Connection):BytesOutput {
        var out = new BytesOutput();
        out.bigEndian = true;
        return out;
    }


    function finishSend() {
        var bytes = sendingBytes.getBytes();
        sendingTo.output.writeVarInt(bytes.length);
        sendingTo.output.writeBytes(bytes, 0, bytes.length);
        sendingTo.output.flush();
    }
}