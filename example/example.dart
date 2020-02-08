import 'package:objd/core.dart';
import 'package:objd_gui/gui.dart';

void main(List<String> args) {
  createProject(Project(
      name: 'gui_test',
      generate:
          Pack(name: 'gui', main: File('main'), load: File('load'), modules: [
        GuiModule.chest(
          Location('-49 56 -36'),
          placeholder:
              Item(Items.gray_stained_glass_pane, name: TextComponent('')),
          pages: [
            GuiPage(
              [
                EmptySlot(slot: Slot.drop(3, 2)),
                ChangePage.prev(
                  Item(Items.arrow),
                  //countScore: Score(Entity.Self(), 'test'),
                ),
                Interactive(Item(Items.apple), actions: [
                  Log('click'),
                ]
                    //countScore: Score(Entity.Self(), 'test'),
                    ),
                ChangePage.next(
                  Item(Items.arrow),
                  //countScore: Score(Entity.Self(), 'test'),
                ),
              ],
              fillEmptySlots: true,
            ),
            GuiPage(
              [
                EmptySlot(slot: Slot.drop(3, 2)),
                ChangePage.prev(
                  Item(Items.arrow),
                  //countScore: Score(Entity.Self(), 'test'),
                ),
                Interactive(
                  Item(Items.apple),
                  actions: [
                    Log('click'),
                  ],
                  countScore: Score(Entity.Player(), 'objd_gui_count'),
                ),
                ChangePage.next(
                  Item(Items.arrow),
                  //countScore: Score(Entity.Self(), 'test'),
                ),
                Interactive(Item(Items.apple))
              ],
              fillEmptySlots: true,
            ),
          ],
        )
      ])));
}
