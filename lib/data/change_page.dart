import 'package:objd/basic/types/item.dart';
import 'package:objd/basic/types/slot.dart';

import 'gui_slot.dart';

class ChangePage extends GuiSlot {
  final ChangePageMode mode;
  final int page;
  final Item item;

  ChangePage(
    this.page,
    this.item, {
    Slot slot,
    this.mode = ChangePageMode.exact,
  })  : assert(page != null),
        assert(item != null),
        assert(mode != null),
        super(slot);
  factory ChangePage.next(
    Item item, {
    Slot slot,
  }) =>
      ChangePage(1, item, slot: slot, mode: ChangePageMode.next);
  factory ChangePage.prev(
    Item item, {
    Slot slot,
  }) =>
      ChangePage(-1, item, slot: slot, mode: ChangePageMode.prev);

  @override
  ChangePage applyWhenPossible({Slot slot, ChangePageMode mode}) => ChangePage(
        page,
        item,
        slot: this.slot ?? slot,
        mode: this.mode ?? mode,
      );
}

enum ChangePageMode { prev, next, exact }
