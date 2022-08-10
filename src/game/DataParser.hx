package game;

import haxe.DynamicAccess;
import sys.io.File;
import haxe.Json;

typedef SubRegistry = {
    var def:Null<String>;
    var entries:Map<String, Int>;
    var protocol_id:Int;
}

typedef BlockStateList = {
    var properties:Map<String, Array<String>>;
    var states:Array<BlockStateData>;
}

typedef BlockStateData = {
    var id:Int;
    var properties:BlockState;
    //var default:Null<Bool>;
}


typedef BlockState = Map<String, String>;

class DataParser {
    public static var dataLocation:String = '~/Desktop/dev/Calamari/data';
    public static var blockStateData:Null<Map<String, BlockStateList>> = null;

    public static function getRegistry(name:Identifier):SubRegistry {
        var content = File.getContent('/home/frying-pan/Desktop/dev/Calamari/data/generated/reports/registries.json');
        var registry = Reflect.field(Json.parse(content), name.toString());
        var entries:DynamicAccess<{protocol_id:Int}> = Reflect.field(registry, 'entries');

        var ret = {
            def: Reflect.hasField(registry, 'default') ? Reflect.field(registry, 'default') : null,
            entries: [for (entry => data in entries) entry => data.protocol_id],
            protocol_id: registry.protocol_id
        };
        
        //trace(ret.entries.toString());
        //trace(Reflect.fields(registry.entires));
        return ret;
    }

    static function loadBlockStateData() {
        if (blockStateData != null) return;
        var content = File.getContent('$dataLocation/generated/reports/blocks.json');
        var parsed:DynamicAccess<BlockStateList> = Json.parse(content);

        trace(parsed.get('minecraft:acacia_button').states[0].id);

        
    }

    public static function getBlockStateFromId(id:Int):BlockState {
        for (_ => data in blockStateData) {
            for (state in data.states) {
                if (state.id == id) return state.properties;
            }
        }
        return null;
    }
}