package packet.clientbound;

import Chat.ChatComponent;
import haxe.io.BytesOutput;
import haxe.Json;

using VarIntLong;

class StatusResponsePacket extends ClientboundPacket {
    public function new() {
        super(0x00);
    }
    
    public static var response:Dynamic = {
        version: {
            name: "1.19",
            protocol: 759,
        },
        players: {
            max: 69,
            online: 420,
            sample: [
                {
                    name: "trolled",
                    id: "4566e69f-c907-48ee-8d71-d7ba5aa00d20",
                }
            ]
        },
        description: Json.parse(ChatComponent.buildText('hey bud!').color(Hex('ff00ff')).extra(ChatComponent.buildText(' how are you today').italic(true).color(Hex('40d0e0'))).serialize()),
        previewsChat: false
    }

    public function send(client:Connection) {
        var output = client.output;
        var bytes = new BytesOutput();
        var str = Json.stringify(StatusResponsePacket.response);
        bytes.writeVarInt(this.id);
        bytes.writeVarString(str);
        output.writeVarInt(bytes.length);
        var o = bytes.getBytes();
        output.writeBytes(o, 0, o.length);
        output.flush();
    }
}