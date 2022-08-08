package;

import entity.Entity;

/*enum abstract LegacyColor(Int) {
    var Black = 0x000000; // &0
    var DarkBlue = 0x0000aa; // &1
    var DarkGreen = 0x00aa00; // &2
    var DarkCyan = 0x00aaaa; // &3
    var DarkRed = 0xaa0000; // &4
    var DarkPurple = 0xaa00aa; // &5
    var Gold = 0xffaa00; // &6
    var LightGray = 0xaaaaaa; // &7
    var DarkGray = 0x555555; // &8
    var LightBlue; // &9
    var LightGreen; // &a
    var LightCyan; // &b
    var LightRed; // &c
    var LightPurple; // &d
    var Yellow; // &e
    var White; // &f
}*/

enum Color {
    Black;
    DarkBlue;
    DarkGreen;
    DarkCyan;
    DarkRed;
    DarkPurple;
    Gold;
    LightGray;
    DarkGray;
    LightBlue;
    LightGreen;
    LightCyan;
    LightRed;
    LightPurple;
    Yellow;
    White;
    Hex(code:String);
    Legacy(code:String);
    Reset;
}

enum ClickEvent {
    OpenURL(url:String);
    RunCommand(command:String);
    SuggestCommand(command:String);
    ChangePage(to:Int);
    CopyToClipboard(str:String);

    // not usable:
    // OpenFile(path:String);
    // TwitchUserInfo(???);
}

enum HoverEvent {
    ShowText(text:ChatComponent);
    ShowItem(item:Dynamic);
    ShowEntity(entity:Entity);
}

class ChatComponent {
    public static final LEGACY_COLOR_CHARACTER = '§';
    public var isBold:Null<Bool> = null;
    public var isItalic:Null<Bool> = null;
    public var isUnderlined:Null<Bool> = null;
    public var isStrikethrough:Null<Bool> = null;
    public var isObfuscated:Null<Bool> = null;
    public var usedFont:Null<Identifier> = null;
    public var usedColor:Null<Color> = null;
    public var onInsertion:Null<String>;
    public var clickEvent:Null<ClickEvent>;
    public var hoverEvent:Null<HoverEvent>;
    public var extras:Null<Array<ChatComponent>> = null;

    public function new() {

    }

    public static function buildText(text:String):ChatComponent {
        var ret = new StringComponent();
        ret.text = text;
        return ret;
    }

    public function bold(val:Bool):ChatComponent {
        this.isBold = val;
        return this;
    }

    public function italic(val:Bool):ChatComponent {
        this.isItalic = val;
        return this;
    }

    public function underline(val:Bool):ChatComponent {
        this.isUnderlined = val;
        return this;
    }

    public function strike(val:Bool):ChatComponent {
        this.isStrikethrough = val;
        return this;
    }

    public function obfuscate(val:Bool):ChatComponent {
        this.isObfuscated = val;
        return this;
    }

    public function font(fnt:Identifier):ChatComponent {
        this.usedFont = fnt;
        return this;
    }

    public function color(col:Color):ChatComponent {
        this.usedColor = col;
        return this;
    }

    public function extra(component:ChatComponent):ChatComponent {
        if (this.extras == null) this.extras = [];
        this.extras.push(component);
        return this;
    }

    public function serialize():String {
        var json = '{';
        if (this.isBold != null) json += '"bold":$isBold,';
        if (this.isItalic != null) json += '"italic":$isItalic,';
        if (this.isUnderlined != null) json += '"underlined":$isUnderlined,';
        if (this.isStrikethrough != null) json += '"strikethrough":$isStrikethrough,';
        if (this.isObfuscated != null) json += '"obfuscated":$isObfuscated,';
        if (this.usedColor != null) json += '"color":"${ChatComponent.serializeColor(this.usedColor)}",';

        return json.substr(0, json.length - 2) + '}';
    }

    public static function serializeColor(col:Color):String {
        return switch col {
            case Black: 'black';
            case DarkBlue: 'dark_blue';
            case DarkGreen: 'dark_green';
            case DarkCyan: 'dark_aqua';
            case DarkRed: 'dark_red';
            case DarkPurple: 'dark_purple';
            case Gold: 'gold';
            case LightGray: 'gray';
            case DarkGray: 'dark_gray';
            case LightBlue: 'blue';
            case LightGreen: 'green';
            case LightCyan: 'aqua';
            case LightRed: 'red';
            case LightPurple: 'light_purple';
            case Yellow: 'yellow';
            case White: 'white';
            case Reset: 'reset';
            case Legacy(code): code;
            case Hex(code): '#$code';
        }
    }
}

class StringComponent extends ChatComponent {
    public var text:String;
}

class TranslationComponent extends ChatComponent {
    public var translation:String;
    public var with:Array<ChatComponent>;
}

class KeybindComponent extends ChatComponent {
    public var keybind:String;
}

typedef ScoreComponentData = {
    var name:String;
    var objective:String;
    var value:String;
}

class ScoreComponent extends ChatComponent {
    public var score:ScoreComponentData;
}

class SelectorComponent extends ChatComponent {
    var selector:String;
}