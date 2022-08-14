package game.world;

import haxe.io.Input;
import game.DataParser.BlockState;
import haxe.io.Output;

using VarIntLong;

class Chunk {
    public static function getGlobalPaletteIdFromState(state:BlockState):Int {
        var ret:Int = -1;
        for (name => data in DataParser.blockStateData) {
            for (bstate in data.states) {
                var matches:Bool = true;
                for (key => value in bstate.properties) {
                    if (value != state[key]) {
                        matches = false;
                        break;
                    }
                }
                if (matches) {
                    return bstate.id;
                }
            }
        }
        return ret;
    }

    public static function getStateFromGlobalPaletteId(id:Int):Null<BlockState> {
        for (name => data in DataParser.blockStateData) {
            for (state in data.states) {
                if (state.id == id) {
                    return state.properties;
                }
            }
        }
        return null;
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
    public function idForState(state:BlockState):Int;
    public function stateForId(id:Int):BlockState;
    public var bitsPerBlock(get, never):Int;
    public function read(input:Input):Void;
    public function write(output:Output):Void;
}

class DirectPalette implements PalettedContainer {
    public var bitsPerBlock(get, never):Int;

    public function get_bitsPerBlock():Int {
        return Math.ceil(Math.log(DataParser.blockStateCount));
    }

    public function new() {}

    public function idForState(state:BlockState):Int {
        return Chunk.getGlobalPaletteIdFromState(state);
    }

    public function stateForId(id:Int):BlockState {
        return Chunk.getStateFromGlobalPaletteId(id);
    }

    public function read(input:Input) {

    }

    public function write(output:Output) {

    }
}

class IndirectPalette implements PalettedContainer {
    public var bitsPerBlock(get, never):Int;
    private var _bitsPerBlock:Int;
    var idToState:Map<Int, BlockState>;
    var stateToId:Map<BlockState, Int>;

    public function get_bitsPerBlock():Int {
        return _bitsPerBlock;
    }

    public function new(bitsPerBlock:Int) {
        this._bitsPerBlock = bitsPerBlock;
    }

    public function idForState(state:BlockState):Int {
        return stateToId.get(state);
    }

    public function stateForId(id:Int):BlockState {
        return idToState.get(id);
    }

    public function read(input:Input) {
        idToState = [];
        stateToId = [];

        var length = input.readVarInt();

        for (i in 0...length) {
            var stateId = input.readVarInt();
            var state = Chunk.getStateFromGlobalPaletteId(stateId);
            idToState.set(stateId, state);
            stateToId.set(state, stateId);
        }
    }

    public function write(output:Output) {
        
    }
} 