import 'package:objd/basic/types/item.dart';

import 'gui_slot.dart';

class GuiPage {
  // number!!
  List<GuiSlot> slots;
  Item placeholder;
  bool fillEmptySlots;

  GuiPage(
    this.slots, {
    this.placeholder,
    this.fillEmptySlots,
  }) : assert(slots != null);
}
