package command;

enum abstract SuggestionType(String) {
    var AskServer = 'minecraft:ask_server';
    var AllRecipes = 'minecraft:all_recipes';
    var AvailableSounds = 'minecraft:available_sounds';
    var AvailableBiomes = 'minecraft:available_biomes';
    var SummonableEntities = 'minecraft:summonable_entities';
}

enum BrigadierNode {
    RootNode(children:Array<BrigadierNode>);
    LiteralNode(children:Array<BrigadierNode>, name:String, isExecutable:Bool);
    ArgumentNode(children:Array<BrigadierNode>, name:String, isExecutable:Bool, suggestionType:SuggestionType);
}

