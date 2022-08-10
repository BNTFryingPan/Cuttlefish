package game.world;

import haxe.io.Input;
import game.DataParser.BlockState;
import haxe.io.Output;

class Chunk {
    public static function getGlobalPaletteIdFromState(state:BlockState):Int {
        var ret:Int = -1;
        for (name => data in DataParser.blockStateData) {
            for (bstate in data.states) {
                if (
            }
        }
        return ret
    }

    public final x:Int;
    public final y:Int;

    public var blockEntities:Array<BlockEntity> = [];

    public function new(x, y) {
        this.x = x;
        this.y = y;
    }

    public static function getChunk(x:Int, y:Int):Chunk {
        var chunk = new Chunk(x, y);

        return chunk;
    }

    public function writeToStream(out:Output) {

    }
}

class ChunkSection {
    public function new() {

    }

    public function writeToStream(out:Output) {

    }
}

interface PalettedContainer {
    public function idForState(state:Dynamic):Int;
    public function stateForId(id:Int):Dynamic;
    public var bitsPerBlock:Int;
    public function read(input:Input);
    public function write(output:Output);
}

class DirectPalette implements PalettedContainer {
    
}

class IndirectPalette implements PalettedContainer {
    public var bitsPerBlock:Int;
    var idToState:Map<

    public function new(bitsPerBlock:Int) {
        this.bitsPerBlock = bitsPerBlock;
    }

    public function idForState(state:Dynamic):Int {

    }
} 