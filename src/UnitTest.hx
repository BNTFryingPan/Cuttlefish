package;

import haxe.Exception;
import game.DataParser;
import sys.io.File;
import packet.clientbound.PlayLoginPacket;
import haxe.io.BytesOutput;
import haxe.io.BytesInput;
import NBT;

using StringTools;
using VarIntLong;


/**
    i made this to sanity check my parsing of var ints. it worked fine.
    but this testing code sucks and should probably be improved at some point
**/
class UnitTest {
    public static function main() {
        /*testVarInt(0);
        testVarInt(1);
        testVarInt(2);
        testVarInt(127);
        testVarInt(128);
        testVarInt(255);
        testVarInt(25565);
        testVarInt(2097151);
        testVarInt(2147483647);
        testVarInt(-1);
        testVarInt(-2147483648);

        testNBT();*/

        try {
            //DataParser.getEntityRegistry();
        } catch (e:Exception) {
            trace(e.stack);
        }
    }

    static function testVarInt(number:Int) {
        var output = new BytesOutput();
        output.writeVarInt(number);
        var bytes = output.getBytes();
        var input = new BytesInput(bytes);
        var result = input.readVarInt();

        trace('${result} == ${number}: ${result == number} ${bytes.toHex()}');
    }

    static var tag = TAG_Compound('hello world', [TAG_String('name', 'bananrama')]);

    static function testNBT() {
        var output = new BytesOutput();
        output.bigEndian = true;
        //NBT.writeToStream(output, tag);
        NBT.writeToStream(output, PlayLoginPacket.REGISTRY_TAG);
        var bytes = output.getBytes();
        trace('write: ${bytes.toHex()}');
        File.write('./test.nbt', true).write(bytes);
        var input = new BytesInput(bytes);
        var result = NBT.readFromStream(input);
        trace(result);
    }
}

// 0a 00 0b 68 65 6c 6c 6f 20 77 6f 72 6c 64 08 00 04 6e 61 6d 65 00 09 42 61 6e 61 6e 72 61 6d 61 00
// 0a 00 0b 68 65 6c 6c 6f 20 77 6f 72 6c 64 08 00 04 6e 61 6d 65 00 09 62 61 6e 61 6e 72 61 6d 61 00