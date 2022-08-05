package;

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
    public static function readFromStream(input:Input, inList=false, ?type:Int):Tag {
        var tagType = input.readByte();
        var tagName;
        if (!inList && tagType != 0) {
            var nameLen = input.readInt8();
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