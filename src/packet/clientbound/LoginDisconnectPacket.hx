package packet.clientbound;

import Chat.ChatComponent;

class LoginDisconnectPacket extends ClientboundPacket {
   public var message:ChatComponent;
   
   public function new(msg:ChatComponent) {
      super(0x00);
      this.message = msg;
   }

   public function send(to:Connection) {
      var out = beginSend(to);
      out.writeString(message.serialize());
   }
}