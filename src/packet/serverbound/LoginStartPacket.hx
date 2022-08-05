package packet.serverbound;

import haxe.Int64;
import haxe.io.Bytes;

using VarIntLong;

class LoginStartPacket extends ServerboundPacket {
    public var name:String;
    public var hasSignatureData:Bool;
    public var timestamp:Null<Int64>;
    public var pubKeyLen:Null<Int>;
    public var pubKey:Null<Bytes>;
    public var sigLen:Null<Int>;
    public var sig:Null<Bytes>;

    public function new() {
        super(0x00);
    }

    public static function read(client:Connection):LoginStartPacket {
        var stream = client.input;
        var packet = new LoginStartPacket();
        packet.name = stream.readVarString();
        packet.hasSignatureData = stream.readByte() == 0x01;
        if (!packet.hasSignatureData) return packet;
        packet.timestamp = Int64.make(stream.readInt32(), stream.readInt32());
        packet.pubKeyLen = stream.readVarInt();
        packet.pubKey = stream.read(packet.pubKeyLen);
        packet.sigLen = stream.readVarInt();
        packet.sig = stream.read(packet.sigLen);
        return packet;
    }
}