import 'package:objd/core.dart';
import 'package:objd_gui/gui.dart';

void main(List<String> args) {
  createProject(
    Project(
      name: 'gui_test',
      version: 17,
      generate: Pack(
        name: 'gui',
        load: File('load'), // important! to load scoreboards
        main: File(
          'main',
          child: Execute.at(
            Entity(
              type: Entities.armor_stand,
              tags: ['custom_gui_location'],
            ),
            children: [
              GuiModule.chest(
                Location.here(),
                pages: [
                  GuiPage(
                    [
                      Placeholder(
                        slot: Slot.chest(2, 1),
                        item: Item(
                          Items.black_stained_glass_pane,
                        ), // overwritten the lame gray one
                      ),
                      EmptySlot(
                        slot: Slot.chest(2, 2),
                      ),
                      Interactive(
                        Item(Items.stone),
                        slot: Slot.chest(2, 5),
                        actions: [
                          Log('clicked stone'),
                        ],
                        countScore: Score(Entity.Player(), 'custom_score'),
                      ),
                      ChangePage(
                        2,
                        Item(Items.arrow),
                        slot: Slot.chest(3, 9),
                      ),
                    ],
                    fillEmptySlots: true,
                    placeholder: Item(Items.gray_stained_glass_pane),
                  ),
                  GuiPage(
                    [
                      Interactive(
                        Item(Items.apple),
                        actions: [
                          Log('MY Nice Apple'),
                        ],
                      ),
                      EmptySlot(
                        slot: Slot.chest(1, 2),
                      ),
                    ],
                    fillEmptySlots: true,
                  ),
                ],
                placeholder: Item(Items.light_gray_stained_glass_pane),
                globalSlots: [
                  ChangePage.prev(
                    Item(Items.arrow),
                    slot: Slot.chest(3, 1),
                  ),
                  ChangePage.next(
                    Item(Items.arrow),
                    slot: Slot.chest(3, 9),
                  ),
                ],
                countScore: 'my_count',
                pageScore: 'my_page',
              )
            ],
          ),
        ),

        modules: [
          // or here
        ],
      ),
    ),
  );
}
