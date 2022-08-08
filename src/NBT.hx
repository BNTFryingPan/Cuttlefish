package;

import haxe.io.Output;
import haxe.io.Input;
import haxe.io.Bytes;
import haxe.Int64;

using VarIntLong;
using StringTools;

enum Tag {
    TAG_End;
    TAG_Byte(name:String, data:Int);
    TAG_Short(name:String, data:Int);
    TAG_Int(name:String, data:Int);
    TAG_Long(name:String, data:Int64);
    TAG_Float(name:String, data:Float);
    TAG_Double(name:String, data:Float);
    TAG_Byte_Array(name:String, data:Bytes);
    TAG_String(name:String, data:String);
    TAG_List(name:String, data:Array<Tag>, type:Int);
    TAG_Compound(name:String, data:Array<Tag>);
    TAG_Int_Array(name:String, data:Array<Int>);
    TAG_Long_Array(name:String, data:Array<Int64>);
}

class NBT {
    public static function writeToStream(out:Output, tag:Tag, inList=false) {
        function writeName() {
            out.writeInt16(tag.getParameters()[0].length);
            out.writeString(tag.getParameters()[0]);
        }
        switch tag {
            case TAG_End:
                if (!inList) out.writeByte(0);
            case TAG_Byte(_, data):
                if (!inList) out.writeByte(1);
                if (!inList) writeName();
                out.writeByte(data);
            case TAG_Short(_, data):
                if (!inList) out.writeByte(2);
                if (!inList) writeName();
                out.writeInt16(data);
            case TAG_Int(_, data):
                if (!inList) out.writeByte(3);
                if (!inList) writeName();
                out.writeInt32(data);
            case TAG_Long(_, data):
                if (!inList) out.writeByte(4);
                if (!inList) writeName();
                out.writeInt64(data);
            case TAG_Float(_, data):
                if (!inList) out.writeByte(5);
                if (!inList) writeName();
                out.writeFloat(data);
            case TAG_Double(_, data):
                if (!inList) out.writeByte(6);
                if (!inList) writeName();
                out.writeDouble(data);
            case TAG_Byte_Array(_, data):
                if (!inList) out.writeByte(7);
                if (!inList) writeName();
                out.writeByte(data.length);
                out.write(data);
            case TAG_String(_, data):
                if (!inList) out.writeByte(8);
                if (!inList) writeName();
                out.writeInt16(data.length);
                out.writeString(data);
            case TAG_List(_, data, type):
                if (!inList) out.writeByte(9);
                if (!inList) writeName();
                out.writeByte(type);
                out.writeInt32(data.length);
                for (entry in data) writeToStream(out, entry, true);
            case TAG_Compound(_, data):
                if (!inList) out.writeByte(10);
                if (!inList) writeName();
                for (entry in data) writeToStream(out, entry, false);
                writeToStream(out, TAG_End, false);
            case TAG_Int_Array(_, data):
                if (!inList) out.writeByte(11);
                if (!inList) writeName();
                out.writeInt32(data.length);
                for (entry in data) out.writeInt32(entry);
            case TAG_Long_Array(_, data):
                if (!inList) out.writeByte(12);
                if (!inList) writeName();
                out.writeInt32(data.length);
                for (entry in data) out.writeInt64(entry);
        }
    }

    public static function readFromStream(input:Input, inList=false, ?type:Int):Tag {
        var tagType = input.readByte();
        var tagName = '';
        if (!inList && tagType != 0) {
            var nameLen = input.readInt16();
            tagName = input.readString(nameLen);
        }

        switch tagType {
            case 0:
                return TAG_End;
            case 1:
                return TAG_Byte(tagName, input.readByte());
            case 2:
                return TAG_Short(tagName, input.readInt16());
            case 3:
                return TAG_Int(tagName, input.readInt32());
            case 4:
                return TAG_Long(tagName, input.readInt64());
            case 5:
                return TAG_Float(tagName, input.readFloat());
            case 6:
                return TAG_Double(tagName, input.readDouble());
            case 7:
                return TAG_Byte_Array(tagName, input.read(input.readInt32()));
            case 8:
                return TAG_String(tagName, input.readString(input.readUInt16()));
            case 9:
                var arrayType = input.readByte();
                var arrayLength = input.readInt32();
                if (arrayLength > 0 && arrayType == 0) throw 'array with len>0 cannot have type TAG_End';

                if (arrayLength <= 0)
                    return TAG_List(tagName, [], arrayType);

                var array:Array<Tag> = [];
                for (i in 0...arrayLength) {
                    array.push(NBT.readFromStream(input, true));
                }
                return TAG_List(tagName, array, arrayType);
            case 10:
                var tags:Array<Tag> = [];
                while (true) {
                    var next = NBT.readFromStream(input);
                    if (next.match(TAG_End))
                        break;
                    tags.push(next);
                }
                return TAG_Compound(tagName, tags);
            case 11:
                var length = input.readInt32();
                var array:Array<Int> = [];
                for (i in 0...length) {
                    array.push(input.readInt32());
                }
                return TAG_Int_Array(tagName, array);
            case 12:
                var length = input.readInt32();
                var array:Array<Int64> = [];
                for (i in 0...length) {
                    array.push(input.readInt64());
                }
                return TAG_Long_Array(tagName, array);
            default:
                throw 'invalid type id `${tagType.hex}` while reading nbt tag';
        }
    }
}