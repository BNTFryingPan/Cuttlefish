package packet.clientbound;

import NBT;
import haxe.Int64;
import haxe.io.Bytes;
using VarIntLong;

class PlayLoginPacket extends ClientboundPacket {
   public function new() {
      super(0x23);
   }

   static var REG_BIOMES = TAG_Compound('minecraft:worldgen/biome', [
      TAG_String('type', 'minecraft:worldgen/biome'),
      TAG_List('value', [
         TAG_Compound('', [
            TAG_String('name', 'minecraft:plains'),
            TAG_Int('id', 0),
            TAG_Compound('element', [
               TAG_String('precipitation', 'rain'),
               TAG_Float('depth', 0),
               TAG_Float('temperature', 1),
               TAG_Float('scale', 0),
               TAG_Float('downfall', 0),
               TAG_String('category', 'plains'),
               TAG_Compound('effects', [
                  TAG_Int('sky_color', 0x00aaff),
                  TAG_Int('water_fog_color', 0x0055ff),
                  TAG_Int('fog_color', 0xffffff),
                  TAG_Int('water_color', 0x0066ff),
               ])
            ])
         ])
      ], 10)]
   );

   static var REG_DIMS = TAG_Compound('minecraft:dimension_type', [TAG_String('type', 'minecraft:dimension_type'), TAG_List('value', [
      TAG_Compound('', [TAG_String('name', 'minecraft:overworld'), TAG_Int('id', 0), TAG_Compound('element', [
         TAG_Byte('piglin_safe', 0x00),
         TAG_Byte('has_raids', 0x01),
         TAG_Int('monster_spawn_light_level', 0),
         TAG_Int('monster_spawn_block_light_limit', 0),
         TAG_Byte('natural', 0x01),
         TAG_Float('ambient_light', 1.0),
         TAG_String('infiniburn', '#'),
         TAG_Byte('respawn_anchor_works', 0x00),
         TAG_Byte('has_skylight', 0x01),
         TAG_Byte('bed_works', 0x01),
         TAG_String('effects', 'minecraft:overworld'),
         TAG_Int('min_y', -64),
         TAG_Int('height', Std.int(256*1.5)),
         TAG_Int('logical_height', 256),
         TAG_Double('coordinate_scale', 1),
         TAG_Byte('ultrawarm', 0x00),
         TAG_Byte('has_ceiling', 0x00),
      ])])
   ], 10)]);
   public static var REGISTRY_TAG = TAG_Compound('', [REG_DIMS, REG_BIOMES]);

   public function send(client:Connection) {
      var out = this.beginSend(client);
      out.writeInt32(12);
      out.writeByte(0x01);
      out.writeByte(0x00);
      out.writeByte(0x01);
      out.writeVarInt(1);
      out.writeVarString('minecraft:world');
      NBT.writeToStream(out, REGISTRY_TAG);
      out.writeVarString('minecraft:overworld');
      out.writeVarString('minecraft:world');
      out.writeInt64(Int64.make(10523243, 904328423));
      out.writeVarInt(0);
      out.writeVarInt(2);
      out.writeVarInt(2);
      out.writeByte(0x00);
      out.writeByte(0x01);
      out.writeByte(0x00);
      out.writeByte(0x00);
      out.writeByte(0x00);
      this.finishSend();
   }
}