package;

import haxe.io.BytesInput;
import haxe.io.Bytes;
import haxe.io.Output;
import haxe.Int64;
import haxe.io.Input;

class VarIntLong {
    public static var SEGMENT_BITS = 0x7f;
    public static var CONTINUE_BIT = 0x80;

    public static function readVarInt(inp:Input):Int {
        var value = 0;
        var pos = 0;
        var byte;

        while (true) {
            byte = inp.readByte();
            value |= (byte & SEGMENT_BITS) << pos;
            pos += 7;
            if ((byte & CONTINUE_BIT) == 0) break;
            if (pos >= 32) throw "VarInt is too long!";
        }
        return value;
    }

    public static function readVarLong(inp:Input):Int64 {
        var value:Int64 = 0;
        var pos = 0;
        var byte;

        while (true) {
            byte = inp.readByte();
            value |= (byte & SEGMENT_BITS) << pos;
            if ((byte & CONTINUE_BIT) == 0) break;
            pos += 7;
            if (pos >= 64) throw "VarLong is too long!";
        }
        return value;
    }

    public static function readVarString(inp:Input):String {
        var len = readVarInt(inp);
        return inp.readString(len);
    }

    public static function writeVarInt(out:Output, value:Int) {
        while (true) {
            if ((value & ~SEGMENT_BITS) == 0) {
                out.writeByte(value);
                return;
            }
            out.writeByte((value & SEGMENT_BITS) | CONTINUE_BIT);
            value >>>= 7;
        }
    }

    public static function writeVarLong(out:Output, value:Int64) {
        while (true) {
            if ((value & ~SEGMENT_BITS) == 0) {
                out.writeByte(value.low);
                return;
            }
            out.writeByte((value.low & SEGMENT_BITS) | CONTINUE_BIT);
            value >>>= 7;
        }
    }

    public static function writeVarString(out:Output, str:String) {
        writeVarInt(out, str.length);
        out.writeString(str);
    }

    public static function readInt64(inp:Input):Int64 {
        var high = inp.readInt32();
        var low = inp.readInt32();
        return Int64.make(high, low);
    }

    public static function writeInt64(out:Output, value:Int64) {
        out.writeInt32(value.high);
        out.writeInt32(value.low);
    }

    public static function readInt12(inp:Input):Int {
        var bytes = inp.read(12);
        var extended = Bytes.alloc(16);
        extended.fill(0, 16, 0);
        extended.blit(4, bytes, 0, 12);
        var o = new BytesInput(extended);
        o.bigEndian = true;
        return o.readInt16();
    }
}