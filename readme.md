# Cuttlefish
A Minecraft: Java Edition server implementation written in Haxe. 

## Currently Supported Features
- Server List Pinging
    - can show any data, including text (including chat components), online/max player count, protocol version, and sample of online players.
- the very start of getting a player to spawn
    - the vanilla client will spawn after a few seconds, but technically it shouldnt
    - when it does spawn, its just a void
- Chat Components
    - there is a chat component builder class that is used to construct and serialize complex formatting in text.
- NBT
    - can currently convert NBT tags to bytes, but reading them from bytes appears to be broken for now

## Features Being Worked On
- properly spawning the player
- sending a flat world

## Planned Features
- authentication and protocol encryption (Piracy is not supported, but impossible to prevent until both of these are added)
- chat
- configuration files for server list ping info and other stuff
- bungeecord/velocity support?
- MiniMessage-like format for easily using advanced chat component features

## Compiling
Being written in Haxe, Cuttlefish can be compiled to many different targets. Cuttlefish only supports sys targets that have threading support. This means that the supported targets are currently C++, C#, Hashlink, Java (or JVM bytecode directly), Neko, and Python. NodeJS is not supported because `hxnodejs` does not support threads yet. To test without worrying about downloading anything extra, the following should work:
```
git clone https://github.com/LeotomasMC/Cuttlefish.git
cd Cuttlefish
haxelib install uuid
haxelib install hxp
haxelib run hxp --install-hxp-alias
hxp test neko
```
the last command `hxp test neko` will compile Cuttlefish for the Neko target, and then run the compiled output automatically.
<!-- neko is the "default" target here because a barebones haxe installion will include it, while other targets may require additional setup><-->
If you want to compile for specific targets, use `hxp build`, followed by a list of target flags. The flags for each target are as follows:
| Target Name   | Supported Flags   |
|---------------|-------------------|
| C++           | `-cpp` `-c++` `-cplusplus` |
| C#            | `-csharp` `-cs`   |
| Java          | `-java`           |
| Java Bytecode | `-jvm`            |
| Hashlink      | `-hl` `-hashlink` |
| Neko          | `-neko`           |
| Python        | `-py`             |

note that some targets may require additional setup. see the haxe target details documentation to setup other targets. 
