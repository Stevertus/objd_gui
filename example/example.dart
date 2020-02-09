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
          GuiModule.chest(
            Location('-49 56 -36'),
            // Item(Items.chest_minecart),
            // name: TextComponent('Custom GUI'),
            // alwaysActive: false,
            placeholder: Item(
              Items.gray_stained_glass_pane,
              name: TextComponent(''),
            ),
            globalSlots: [
              ChangePage.prev(Item(Items.arrow)),
              Interactive(Item(Items.apple), actions: [
                Log('click'),
              ]),
              ChangePage.next(
                Item(Items.arrow),
              ),
            ],
            pages: [
              GuiPage(
                [
                  EmptySlot(slot: Slot.chest(3, 2)),
                ],
                fillEmptySlots: true,
              ),
              GuiPage(
                [
                  EmptySlot(slot: Slot.chest(3, 8)),
                  Interactive(
                    Item(Items.apple),
                    slot: Slot.chest(2, 5),
                    actions: [
                      Log('pg2'),
                    ],
                  )
                ],
                fillEmptySlots: true,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
