package game;

import haxe.io.Input;

using VarIntLong;

class BlockLocation {
    public var x:Int = 0;
    public var y:Int = 0;
    public var z:Int = 0;

    public function new(x:Int, y:Int, z:Int) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public static function readFromStream(stream:Input):BlockLocation {
        var x = stream.readInt24();
        var z = stream.readInt24();
        var y = stream.readInt12();
        return new BlockLocation(x, y, z);
    }
}