package packet.serverbound;

import haxe.io.Input;

using VarIntLong;

class HandshakePacket extends ServerboundPacket {
    public var protocolVersion:Int;
    public var serverAddress:String;
    public var serverPort:Int;
    public var status:Int;

    public function new() {
        super(0x00);
    }

    public static function read(stream:Input):HandshakePacket {
        var packet = new HandshakePacket();
        packet.protocolVersion = stream.readVarInt();
        packet.serverAddress = stream.readVarString();
        packet.serverPort = stream.readUInt16();
        packet.status = stream.readVarInt();
        return packet;
    }

    override public function handle(client:Connection) {
        //new StatusResponsePacket().send(client);
    }
}