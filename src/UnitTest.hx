package;

import haxe.io.BytesOutput;
import haxe.io.BytesInput;

using StringTools;
using VarIntLong;


/**
    i made this to sanity check my parsing of var ints. it worked fine.
    but this testing code sucks and should probably be improved at some point
**/
class UnitTest {
    public static function main() {
        testVarInt(0);
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
    }

    static function testVarInt(number:Int) {
        var output = new BytesOutput();
        output.writeVarInt(number);
        var bytes = output.getBytes();
        var input = new BytesInput(bytes);
        var result = input.readVarInt();

        trace('${result} == ${number}: ${result == number} ${bytes.toHex()}');
    }
}