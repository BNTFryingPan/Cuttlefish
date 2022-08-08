package;

class Identifier {
    public static final DEFAULT_NAMESPACE = 'minecraft';

    public var namespace:String;
    public var key:String;

    public function new(namespace:String, key:String) {
        this.namespace = namespace;
        this.key = key;
    }

    public static function fromString(str:String) {
        var colonPos = str.indexOf(':');
        var namespace:String = Identifier.DEFAULT_NAMESPACE;

        if (colonPos != -1) {
            namespace = str.substr(0, colonPos);
        }
    }

    public function toString():String {
        return '$namespace:$key';
    }
}