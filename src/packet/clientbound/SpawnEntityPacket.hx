package packet.clientbound;

import haxe.io.Bytes;

class SpawnEntityPacket extends ClientboundPacket {
    public var entityId:Int;
    public var entityUuid:Bytes;
    public var type:Int;
    
}