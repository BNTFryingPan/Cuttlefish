# Cuttlefish
A Minecraft server written in Haxe.

## Currently Supported Features
- Server List Pinging
    - can show any data, including text, online/max player count, protocol version, and sample of online players.
- thats literally it for now

## Features Being Worked On
- login success packet (to login to the server)
- protocol encryption
- some other background stuff

## Compiling
Being written in Haxe, Cuttlefish can be compiled to many different targets. Cuttlefish only supports sys targets that have threading support. This means that the supported targets are currently C++, C#, Hashlink, Java (or JVM bytecode directly), Neko, and Python. NodeJS is not supported because `hxnodejs` does not support threads yet. To test without worrying about downloading anything extra, the following should work:
```git clone https://github.com/LeotomasMC/Cuttlefish.git
cd Cuttlefish
haxelib install uuid
haxelib install hxp
haxelib run hxp --install-hxp-alias
hxp test neko```
the last command `hxp test neko` will compile Cuttlefish for the Neko target, and then run the compiled output automatically.