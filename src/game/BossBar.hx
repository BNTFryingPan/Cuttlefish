package game;

import Chat;

enum abstract BossBarColor(Int) {
    var Pink;
    var Blue;
    var Red;
    var Green;
    var Yellow;
    var Purple;
    var White;
}

enum abstract BossBarNotches(Int) {
    var NoNotches;
    var SixNotches;
    var TenNotches;
    var TwelveNotches;
    var TwentyNotches;
}

class BossBar {
    var uuid:UUID;
    var name:ChatComponent;
    var percent:Float = 1;
    var color:BossBarColor = Pink;
    var notches:BossBarNotches = SixNotches;
    var darkenSky:Bool = false;
    var playMusic:Bool = false;
    var createFog:Bool = false;
}