import 'package:objd/basic/types/item.dart';
import 'package:objd/basic/types/slot.dart';
import 'package:objd_gui/data/interactive_slot.dart';

import 'gui_slot.dart';

class Placeholder extends GuiSlot {
  final Item item;

  Placeholder({this.item, Slot slot}) : super(slot);

  @override
  Placeholder applyWhenPossible({Item item, Slot slot}) =>
      Placeholder(item: this.item ?? item, slot: this.slot ?? slot);
}
