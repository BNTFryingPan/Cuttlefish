package game;

import game.BlockLocation;

enum ParticleDefinition {
    Void(id:Int);
    BlockState(id:Int, blockState:Int);
    Dust(id:Int, red:Float, green:Float, blue:Float, scale:Float);
    DustTransition(id:Int, red:Float, green:Float, blue:Float, scale:Float, toRed:Float, toGreen:Float, toBlue:Float);
    Vibration(id:Int, sourceType:String, blockPosition:BlockLocation, entityId:Int, entityEyeHeight:Float, ticks:Int);
}

class Particle {
    public static final Particles:Map<String, ParticleDefinition> = [];

    public var identifier:Identifier;
    public var data:ParticleDefinition;
    
}