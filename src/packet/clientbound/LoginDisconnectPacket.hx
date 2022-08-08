package packet.clientbound;

import Chat.ChatComponent;

using VarIntLong;

class LoginDisconnectPacket extends ClientboundPacket {
   public var message:ChatComponent;
   
   public function new(msg:ChatComponent) {
      super(0x00);
      this.message = msg;
   }

   public function send(to:Connection) {
      var out = beginSend(to);
      out.writeVarString(message.serialize());
      finishSend();
   }
}