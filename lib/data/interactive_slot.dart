import 'package:objd/basic/score.dart';
import 'package:objd/basic/types/item.dart';
import 'package:objd/basic/types/slot.dart';
import 'package:objd/basic/widget.dart';

import 'gui_slot.dart';

class Interactive extends GuiSlot {
  final Item item;
  final List<Widget> _actions;
  final Score countScore;

  List<Widget> get actions => _actions ?? [];

  Interactive(
    this.item, {
    Slot slot,
    List<Widget> actions,
    this.countScore,
  })  : _actions = actions,
        assert(item != null),
        super(slot);

  @override
  Interactive applyWhenPossible({
    Item item,
    Slot slot,
    List<Widget> actions,
    Score count,
  }) =>
      Interactive(
        item ?? this.item,
        slot: slot ?? this.slot,
        actions: actions ?? this.actions,
        countScore: count ?? countScore,
      );
}
