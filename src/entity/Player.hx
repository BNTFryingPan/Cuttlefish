package entity;

import uuid.Uuid;

class Player extends Entity {
    public var uuid:String;
    public var name:String;

    public function new(uuid:String, name:String) {
        trace('constructor');
        this.uuid = uuid;
        trace('set uuid');
        this.name = name;
    }
}