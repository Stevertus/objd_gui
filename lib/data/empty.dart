import 'package:objd/basic/types/slot.dart';

import 'gui_slot.dart';

class EmptySlot extends GuiSlot {
  EmptySlot({Slot slot}) : super(slot);

  @override
  EmptySlot applyWhenPossible({Slot slot}) =>
      EmptySlot(slot: this.slot ?? slot);
}
