import 'package:objd/core.dart';
import 'package:objd_gui/gui.dart';

void main(List<String> args) {
  createProject(
    Project(
      name: 'gui_test',
      generate: Pack(
        name: 'gui',
        main: File('main'),
        load: File('load'),
        modules: [
          GuiModule.item(
            Item(Items.chest_minecart),
            name: TextComponent('Custom GUI'),
            alwaysActive: false,
            placeholder: Item(
              Items.gray_stained_glass_pane,
              name: TextComponent(''),
            ),
            pages: [
              GuiPage(
                [
                  EmptySlot(slot: Slot.drop(3, 2)),
                  ChangePage.prev(
                    Item(Items.arrow),
                  ),
                  Interactive(Item(Items.apple), actions: [
                    Log('click'),
                  ]),
                  ChangePage.next(
                    Item(Items.arrow),
                  ),
                ],
                fillEmptySlots: true,
              ),
              GuiPage(
                [
                  EmptySlot(slot: Slot.drop(3, 2)),
                  ChangePage.prev(
                    Item(Items.arrow),
                  ),
                  Interactive(
                    Item(Items.apple),
                    actions: [
                      Log('click pg2'),
                    ],
                    countScore: Score(Entity.Player(), 'objd_gui_count'),
                  ),
                  ChangePage.next(
                    Item(Items.arrow),
                  ),
                  Interactive(Item(Items.apple), slot: Slot.chest(2, 5))
                ],
                fillEmptySlots: true,
              ),
            ],
          )
        ],
      ),
    ),
  );
}
