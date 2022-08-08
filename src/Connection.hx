package;

import Chat;
import Chat.ChatComponent;
import packet.clientbound.LoginDisconnectPacket;
import packet.clientbound.PlayLoginPacket;
import haxe.Exception;
import haxe.io.Bytes;
import game.BlockLocation;
import haxe.Int64;
import packet.clientbound.LoginSuccessPacket;
import uuid.Uuid;
import entity.Player;
import packet.clientbound.PingResponsePacket;
import packet.serverbound.PingRequestPacket;
import packet.clientbound.StatusResponsePacket;
import packet.serverbound.StatusRequestPacket;
import packet.serverbound.LoginStartPacket;
import packet.serverbound.HandshakePacket;
import haxe.io.Output;
import haxe.io.Input;
import packet.serverbound.ServerboundPacket;
import sys.thread.Thread;
import sys.net.Socket;

using VarIntLong;

enum ClientState {
    Handshaking;
    Status;
    Login;
    Play;
}

class Connection {
    public var state(default, set):ClientState = Handshaking;
    public var socket:Socket;
    private var thread:Thread;
    public var encrypted:Bool = false;

    public var player(get, never):Player;
    var _player:Null<Player> = null;

    function get_player():Player {
        if (hasPlayer())
            return _player;
        throw "Tried getting player before ready";
    }

    public function hasPlayer():Bool {
        return _player != null;
    }

    var socketConnected = true;

    function set_state(s:ClientState):ClientState {
        trace('$state -> $s');
        return this.state = s;
    }

    public var input(get, never):Input;
    public var output(get, never):Output;
    function get_input():Input {return this.socket.input;}
    function get_output():Output {return this.socket.output;}

    public function new(sock:Socket) {
        this.socket = sock;
        // minecraft uses big endian for some reason, while little endian is the default because its more common.
        this.socket.output.bigEndian = true;
        this.socket.input.bigEndian = true;

        trace('new connection from ${this.socket.peer().host.toString()}:${this.socket.peer().port}');
        this.thread = Thread.create(this.loop);
    }

    public function loop() {
        while (socketConnected) {
            try {
                var packet = readPacket();
            } catch (e:haxe.io.Eof) {
                trace('eof, stopping thread');
                return;
            } catch (e:Exception) {
                Sys.stderr().writeString(e.details());
                Sys.stderr().flush();
                //trace('uncaught exception: ${e.toString()}');
                //trace(e.details());
            }
        }
    }

    public function readPacket():ServerboundPacket {
        var packetLen = input.readVarInt();
        var packetId = input.readVarInt();
        return switch packetId {
            case 0x00:
                switch state {
                    case Handshaking:
                        var packet = HandshakePacket.read(input);
                        switch packet.status {
                            case 1:
                                state = Status;
                            case 2:
                                state = Login;
                            default:
                                trace('unknown state after handshake: ${packet.status}');
                        }
                        packet;
                    case Status:
                        var packet = StatusRequestPacket.read(input);
                        new StatusResponsePacket().send(this);
                        packet;
                    case Login:
                        var packet = LoginStartPacket.read(this);
                        var namespace = Bytes.ofString('OfflinePlayer').toHex();
                        this._player = new Player(Uuid.v3(packet.name, namespace), packet.name);
                        //new LoginDisconnectPacket(ChatComponent.buildText('kicked').color(Color.Yellow).underline(true).extra(ChatComponent.buildText(' by ').underline(false).strike(true).color(Color.Hex('ff00ff'))).extra(ChatComponent.buildText('haxe!').color(Gold).italic(true)).extra(ChatComponent.buildText(' wow').obfuscate(true).underline(false).color(Hex('40d0e0')).extra(ChatComponent.buildText('trolled').color(LightGreen).obfuscate(false).font(new Identifier('minecraft', 'alt'))))).send(this);
                        new LoginSuccessPacket().send(this, Uuid.parse(player.uuid), player.name);
                        state = Play;
                        
                        new PlayLoginPacket().send(this);

                        packet;
                    case Play:
                        null;
                }
            case 0x01:
                switch state {
                    case Status:
                        var packet = PingRequestPacket.read(input);
                        PingResponsePacket.sendFromRequestPacket(this, packet);
                        //socket.close();
                        //socketConnected = false;
                        packet;
                    default:
                        null;
                }
            case 0x0C:
                trace('plugin msg');
                null;
            default:
                // unknown packet type. we want to handle it though anyways just in case its useful?
                ServerboundPacket.readUnknownPacket(input, packetLen, packetId);
        }
    }

    public function readBoolean():Bool {
        return this.input.readByte() == 0x01;
    }

    public function readByte():Int {
        return this.input.readByte();
    }

    public function readUByte():Int {
        return this.readByte() + 128;
    }

    public function readShort():Int {
        return this.input.readInt16();
    }

    public function readUShort():Int {
        return this.input.readUInt16();
    }

    public function readInt():Int {
        return this.input.readInt32();
    }

    public function readLong():Int64 {
        var lower = this.readInt();
        var upper = this.readInt();
        return Int64.make(upper, lower);
    }

    public function readFloat():Float {
        return this.input.readFloat();
    }

    public function readDouble():Float {
        return this.input.readDouble();
    }

    public function readString():String {
        return this.input.readVarString();
    }

    // TODO readChat
    // TODO readIdentifier

    public function readVarInt():Int {
        return this.input.readVarInt();
    }

    public function readVarLong():Int64 {
        return this.input.readVarLong();
    }

    // TODO readEntityMetadata
    // TODO readSlot
    // TODO readTag

    public function readPosition():BlockLocation {
        return BlockLocation.readFromStream(this.input);
    }

    public function readAngle():Int {
        return this.input.readByte();
    }

    public function readUUID():UUID {
        return UUID.readFromStream(this.input);
    }

    // TODO readArrayOf
    // TODO readEnum

    public function readByteArray(length:Int):Bytes {
        return this.input.read(length);
    }
}