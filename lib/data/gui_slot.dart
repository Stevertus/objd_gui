import 'package:objd/basic/types/slot.dart';

abstract class GuiSlot {
  final Slot slot;
  GuiSlot(this.slot);

  GuiSlot applyWhenPossible();
}
