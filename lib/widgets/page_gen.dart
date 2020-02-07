import 'package:objd/core.dart';
import 'package:objd_gui/data/change_page.dart';
import 'package:objd_gui/data/gui_slot.dart';
import 'package:objd_gui/data/interactive_slot.dart';
import 'package:objd_gui/data/page.dart';
import 'package:objd_gui/data/placeholder.dart';
import 'package:objd_gui/gui.dart';

class PageGenerator extends Widget {
  int index;
  GuiPage page;
  GuiContainer container;
  List<Interactive> _slots;
  String countScore;
  String pageScore;

  PageGenerator(
    this.page,
    this.container,
    this.countScore,
    this.pageScore, [
    this.index,
  ]) {
    _slots = _getGenSlots();
  }

  List<Interactive> _getGenSlots() {
    final ret = <Interactive>[];
    final slots = page.slots;

    final usedSlots = <int>[];

    // get all the ids that are already occupied
    for (var slot in slots) {
      if (slot.slot != null) {
        usedSlots.add(slot.slot.id);
      }
    }

    var slotCounter = 1;

    for (var slot in slots) {
      Slot currentSlot;
      GuiSlot newSlot;

      if (slot.slot == null) {
        while (usedSlots.indexWhere((v) => container == GuiContainer.inventory
                ? _toInvRow(v) == slotCounter
                : v == slotCounter) >=
            0) {
          slotCounter++;
        }

        currentSlot = _getSlotForContainer(container, slotCounter);

        usedSlots.add(slotCounter);

        newSlot = slot;
        slotCounter++;
      } else {
        newSlot = slot.applyWhenPossible();
        currentSlot = slot.slot.clone();
      }

      if (slot is Placeholder) {
        final item = slot.item ?? page.placeholder;
        assert(
          item != null,
          'Please provide either an item for each placeholder or give a global placeholder!',
        );
        newSlot = Interactive(item);
      }
      if (slot is ChangePage) {
        final s = Score(Entity.Player(distance: Range.to(8)), pageScore);

        final actions = <Widget>[File.execute('gui/clear', create: false)];

        if (slot.mode == ChangePageMode.exact) {
          actions.add(s >> slot.page);
        }
        if (slot.mode == ChangePageMode.next) {
          actions.add(s + slot.page);
        }
        if (slot.mode == ChangePageMode.prev) {
          actions.add(s - slot.page);
        }

        newSlot = Interactive(slot.item, actions: actions);
      }

      if (newSlot is Interactive) {
        var s = newSlot;
        ret.add(
          s.applyWhenPossible(
            item: _createGuiItem(s.item, currentSlot),
            slot: currentSlot,
          ),
        );
      }
    }

    if (page.fillEmptySlots != null && page.fillEmptySlots) {
      assert(page.placeholder != null,
          'You have to provide a placeholder when using fillEmptySlots');

      var length = 27;
      if (container == GuiContainer.inventory) length = 36;
      if (container == GuiContainer.dropper) length = 9;
      if (container == GuiContainer.hopper) length = 5;

      for (var i = 1; i <= length; i++) {
        if (!usedSlots.contains(i)) {
          final slot = _getSlotForContainer(container, i);
          ret.add(
            Interactive(_createGuiItem(page.placeholder, slot), slot: slot),
          );
        }
      }
    }

    return ret;
  }

  List<Widget> clear() {
    if (container == GuiContainer.inventory ||
        container == GuiContainer.enderchest ||
        container == GuiContainer.minecart) {
      return _slots
          .map((s) =>
              ReplaceItem(Entity.Self(), item: Item(Items.air), slot: s.slot))
          .toList();
    }

    return _slots
        .map((s) => ReplaceItem.block(
              Location.here(),
              item: Item(Items.air),
              slot: s.slot,
            ))
        .toList();
  }

  List<ReplaceItem> setItems() {
    if (container == GuiContainer.inventory ||
        container == GuiContainer.enderchest ||
        container == GuiContainer.minecart) {
      return _slots
          .map((s) => ReplaceItem(Entity.Self(), item: s.item, slot: s.slot))
          .toList();
    }

    return _slots
        .map((s) => ReplaceItem.block(
              Location.here(),
              item: s.item,
              slot: s.slot,
            ))
        .toList();
  }

  List<If> itemActions() {
    return _slots.map((s) {
      var item = gson.encode(
        {
          'Slot': Byte(s.slot.id),
          'tag': {
            'objd': {'gui': true},
          },
        },
      );

      return If(
          Condition.not(
            Data.get(Location.here(), path: 'Items[$item]'),
          ),
          then: [
            if (s.actions != null) ...s.actions,
            If(Data.get(Location.here(), path: 'Items[{Slot:${s.slot.id}b}]'),
                then: [
                  Summon(
                    Entities.item,
                    tags: ['objd_gui_dropitem'],
                    nbt: {
                      'Item': Item(
                        Items.stone,
                        count: 1,
                        nbt: {
                          'objd': {'gui': true},
                        },
                      ).getMap(),
                    },
                  ),
                  Data.copy(
                    Entity(type: Entities.item, limit: 1, nbt: {
                      'Item': {
                        'tag': {
                          'objd': {'gui': true},
                        },
                      }
                    }).sort(Sort.nearest),
                    path: 'Item',
                    from: Location.here(),
                    fromPath: 'Items[{Slot:${s.slot.id}b}]',
                  )
                ]),
          ]);
    }).toList();
  }

  @override
  Widget generate(Context context) {
    List<Widget> reset() {
      return [
        Clear(
          Entity.All(distance: Range.to(20)),
          Item('#${context.packId}:all', nbt: {
            'objd': {'gui': true}
          }),
        ),
        Kill(
          Entity(
            type: Entities.item,
            nbt: {
              'Item': {
                'tag': {
                  'objd': {'gui': true}
                },
              },
            },
          ),
        ),
        ...itemActions(),
        Teleport.entity(
          Entity(
            type: Entities.item,
            tags: ['objd_gui_dropitem'],
          ),
          to: Entity.Player(
            distance: Range.to(8),
          ),
        ),
        File.execute(
          'gui/reset_gui${index}',
          child: For.of(setItems()),
        ),
      ];
    }

    final s = Score(Entity.Player(distance: Range.to(8)), countScore);
    var children = <Widget>[
      //s.setToCondition(cond)
      If(Condition.not(s & _slots.length), then: [
        File.execute(
          'gui/actions${index}',
          child: For.of(reset()),
        ),
      ]),
    ];

    for (var slot in _slots) {
      if (slot.countScore != null) {
        children.add(If(slot.countScore > 0, then: [
          Builder((c) {
            if (container == GuiContainer.inventory) {
              return Data.fromScore(
                Entity.Self(),
                path: 'Inventory[{"Slot":${slot.slot.id}b }].Count',
                score: slot.countScore,
              );
            }
            if (container == GuiContainer.enderchest) {
              return Data.fromScore(
                Entity.Self(),
                path: 'EnderItems[{"Slot":${slot.slot.id}b }].Count',
                score: slot.countScore,
              );
            }
            if (container == GuiContainer.minecart) {
              return Data.fromScore(
                Entity.Self(),
                path: 'Items[{"Slot":${slot.slot.id}b }].Count',
                score: slot.countScore,
              );
            }
            return Data.fromScore(
              Location.here(),
              path: 'Items[{"Slot":${slot.slot.id}b }].Count',
              score: slot.countScore,
            );
          })
        ]));
      }
    }

    return For.of(children);
  }
}

int _toInvRow(int id) => id < 9 ? id + 27 : id - 9;

Slot _getSlotForContainer(GuiContainer container, int s) {
  switch (container) {
    case GuiContainer.inventory:
      {
        if (s > 36) {
          throw ('You specified too many items for the inventory!');
        }
        return Slot.inv(s);
      }
    case GuiContainer.chest:
      return Slot.chest(s);

    case GuiContainer.dropper:
      return Slot.drop(s);

    case GuiContainer.minecart:
      {
        if (s > 27) {
          throw ('You specified too many items for the minecart!');
        }
        return Slot.chest(s);
      }
    case GuiContainer.hopper:
      {
        if (s > 5) {
          throw ('You specified too many items for the hopper!');
        }
        return Slot.chest(s);
      }
    case GuiContainer.enderchest:
      return Slot.chest(s, null, true);
  }
  throw (UnsupportedError('$container is not supported'));
}

Item _createGuiItem(Item i, Slot s) => Item.clone(i)
  ..slot = s
  ..tag.addAll({
    'objd': {'gui': true}
  });
