import 'package:objd/core.dart';
import 'package:objd_gui/gui.dart';

void main(List<String> args) {
  createProject(Project(
      name: 'test',
      generate: Pack(name: 'test', main: File('main'), modules: [
        GuiModule.dropper(
          Location.here(),
          pages: [
            GuiPage(
              [
                EmptySlot(slot: Slot.chest(3, 2)),
                Interactive(
                  Item(Items.apple),
                  countScore: Score(Entity.Self(), 'test'),
                )
              ],
              fillEmptySlots: true,
              placeholder:
                  Item(Items.gray_stained_glass_pane, name: TextComponent('')),
            ),
            GuiPage(
              [
                EmptySlot(slot: Slot.chest(3, 2)),
                Interactive(Item(Items.apple))
              ],
              fillEmptySlots: true,
              placeholder: Item(Items.stone_axe),
            ),
          ],
        )
      ])));
}
