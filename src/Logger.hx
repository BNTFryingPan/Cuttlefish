package;

import Chat.Color;

using StringTools;

class Logger {
    public static final ansi_obsfucated = '\u001B[5m';
    public static final ansi_bold = '\u001B[1m';
    public static final ansi_strike = '\u001B[9m';
    public static final ansi_underline = '\u001B[4m';
    public static final ansi_italic = '\u001B[3m';
    public static final ansi_obsfucated_end = '\u001B[25m';
    public static final ansi_bold_end = '\u001B[21m';
    public static final ansi_strike_end = '\u001B[29m';
    public static final ansi_underline_end = '\u001B[24m';
    public static final ansi_italic_end = '\u001B[23m';

    public static function colorToAnsi(col:Color):String {
        switch (col) {
            case Hex(code): return hexAnsi(code);
            case Reset: return '\u001B[m';
            case Legacy(code): return code; // i cant be bothered
            case Black: return hexAnsi('000000');
            case DarkBlue: return hexAnsi('0000aa');
            case DarkGreen: return hexAnsi('00aa00');
            case DarkCyan: return hexAnsi('00aaaa');
            case DarkRed: return hexAnsi('aa0000');
            case DarkPurple: return hexAnsi('aa00aa');
            case Gold: return hexAnsi('ffaa00');
            case LightGray: return hexAnsi('aaaaaa');
            case DarkGray: return hexAnsi('555555');
            case LightBlue: return hexAnsi('5555ff');
            case LightGreen: return hexAnsi('5555ff');
            case LightCyan: return hexAnsi('55ffff');
            case LightRed: return hexAnsi('ff5555');
            case LightPurple: return hexAnsi('ff55ff');
            case Yellow: return hexAnsi('ffff55');
            case White: return hexAnsi('ffffff');
        };
    }

    static function hexAnsi(hex:String):String {
        if (hex.length == 7 && hex.startsWith('#')) hex = hex.substr(1, 6);
        if (hex.length != 6) throw 'Invalid hex code';
        return '\u001B[38;2;${hex.substr(0,2)};${hex.substr(2,2)};${hex.substr(4,2)}m';
    }
}