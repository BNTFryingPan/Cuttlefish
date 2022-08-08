package packet.clientbound;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
using VarIntLong;

class ClientboundPacket {
    var sendingBytes:Null<BytesOutput>;
    var sendingTo:Null<Connection>;

    public var id(get,never):Int;
    private var _id:Int;

    public var extraData:Null<Bytes>;

    function get_id():Int {
        return this._id;
    }

    public function new(id:Int) {
        this._id = id;
        trace('S->C 0x${StringTools.hex(id)}');
    }

    function beginSend(client:Connection):BytesOutput {
        sendingTo = client;
        sendingBytes = new BytesOutput();
        sendingBytes.bigEndian = true;
        sendingBytes.writeVarInt(this.id);
        return sendingBytes;
    }


    function finishSend() {
        var bytes = sendingBytes.getBytes();

        sendingTo.output.writeVarInt(bytes.length);
        sendingTo.output.writeBytes(bytes, 0, bytes.length);
        sendingTo.output.flush();
    }
}