package;

import uuid.Uuid;
import haxe.io.Bytes;
import haxe.io.Output;
import haxe.io.Input;
import haxe.Int64;

using StringTools;

class UUID {
    var lower:Int64;
    var upper:Int64;

    public function new(upper:Int64, lower:Int64) {
        trace('new');
        this.upper = upper;
        this.lower = lower;
    }

    public function compare(other:UUID) {
        if (other.upper != this.upper) return false;
        if (other.lower != this.lower) return false;
        return true;
    }

    public static function readFromStream(stream:Input):UUID {
        var bytes = stream.read(16);
        var upper = bytes.getInt64(0);
        var lower = bytes.getInt64(8);
        return new UUID(upper, lower);
    }

    public function writeToStream(stream:Output) {
        var bytes = Bytes.alloc(16);
        bytes.setInt64(0, this.upper);
        bytes.setInt64(8, this.lower);
        stream.write(bytes);
    }

    public function toString():String {
        return Uuid.hexToUuid('${lower.low.hex}${lower.high.hex}${upper.low.hex}${upper.high.hex}', '');
    }

    public static function fromString(str:String) {
        trace('creating uuid from $str');
        /*var bytes = Uuid.parse(str, '-');
        trace(bytes.getData());
        var upper = bytes.(0);
        trace('${upper.high.hex()}${upper.low.hex()}');
        var lower = bytes.getInt64(64);
        trace(lower);
        //trace(upper.high.hex, upper.low.hex);
        return new UUID(upper, lower);*/
    }
}