library objd_gui;

import 'package:meta/meta.dart';
import 'package:objd/core.dart';
import 'package:objd_gui/data/page.dart';
import 'package:objd_gui/widgets/all_tag.dart';
import 'package:objd_gui/widgets/page_gen.dart';

export 'package:objd_gui/data/page.dart';
export 'package:objd_gui/data/placeholder.dart';
export 'package:objd_gui/data/interactive_slot.dart';
export 'package:objd_gui/data/change_page.dart';
export 'package:objd_gui/data/empty.dart';
export 'package:objd_gui/data/gui_slot.dart';

const _DEF_Count = 'objd_gui_count';
const _DEF_Page = 'objd_gui_page';

class GuiModule extends Module {
  GuiContainer container;
  Location blockLocation;
  Entity targetEntity;
  List<GuiPage> pages;
  Item placeholder;
  String countScore;
  String pageScore;

  GuiModule._(
    this.container,
    this.blockLocation,
    this.targetEntity,
    this.pages,
    this.placeholder,
    this.countScore,
    this.pageScore,
  ) : assert(pages != null && pages.isNotEmpty);

  factory GuiModule.chest(
    Location target, {
    @required List<GuiPage> pages,
    Item placeholder,
    String countScore = _DEF_Count,
    String pageScore = _DEF_Page,
  }) =>
      GuiModule._(
        GuiContainer.chest,
        target,
        null,
        pages,
        placeholder,
        countScore,
        pageScore,
      );

  factory GuiModule.dropper(
    Location target, {
    @required List<GuiPage> pages,
    Item placeholder,
    String countScore = _DEF_Count,
    String pageScore = _DEF_Page,
  }) =>
      GuiModule._(
        GuiContainer.dropper,
        target,
        null,
        pages,
        placeholder,
        countScore,
        pageScore,
      );
  factory GuiModule.hopper(
    Location target, {
    @required List<GuiPage> pages,
    Item placeholder,
    String countScore = _DEF_Count,
    String pageScore = _DEF_Page,
  }) =>
      GuiModule._(
        GuiContainer.hopper,
        target,
        null,
        pages,
        placeholder,
        countScore,
        pageScore,
      );
  factory GuiModule.inventory(
    Entity target, {
    @required List<GuiPage> pages,
    Item placeholder,
    String countScore = _DEF_Count,
    String pageScore = _DEF_Page,
  }) =>
      GuiModule._(
        GuiContainer.inventory,
        null,
        target,
        pages,
        placeholder,
        countScore,
        pageScore,
      );

  factory GuiModule.enderchest(
    Entity target, {
    @required List<GuiPage> pages,
    Item placeholder,
    String countScore = _DEF_Count,
    String pageScore = _DEF_Page,
  }) =>
      GuiModule._(
        GuiContainer.enderchest,
        null,
        target,
        pages,
        placeholder,
        countScore,
        pageScore,
      );
  factory GuiModule.minecart(
    Entity target, {
    @required List<GuiPage> pages,
    Item placeholder,
    String countScore = _DEF_Count,
    String pageScore = _DEF_Page,
  }) =>
      GuiModule._(
        GuiContainer.minecart,
        null,
        target,
        pages,
        placeholder,
        countScore,
        pageScore,
      );

  List<PageGenerator> _pageGens;

  @override
  Widget generate(Context context) {
    _pageGens = pages
        .map(
          (p) => PageGenerator(
            p,
            container,
            countScore,
            pageScore,
            pages.indexOf(p) + 1,
          ),
        )
        .toList();
    final main = File(
      'gui/main',
      child: Builder(
        (context) {
          if (_pageGens.length == 1) return _pageGens.first;

          final score = Score(
            Entity.Player(distance: Range(to: 8)),
            pageScore,
          );
          return For.of(
            _pageGens
                .map(
                  (p) => If(
                    score & p.index,
                    then: [
                      File.execute(
                        'gui/gui${p.index}',
                        child: p,
                      )
                    ],
                  ),
                )
                .toList(),
          );
        },
      ),
    );
    if (blockLocation != null) {
      return Execute.positioned(blockLocation, children: [main, TagAll()]);
    }
    if (targetEntity != null) {
      return Execute.asat(targetEntity, children: [main, TagAll()]);
    }

    throw ('Please provide a non-null argument in the GuiModule');
  }

  @override
  List<File> registerFiles() => [
        File(
          'gui/clear',
          child: Builder(
            (context) {
              if (_pageGens.length == 1) return For.of(_pageGens.first.clear());

              final score = Score(
                Entity.Player(distance: Range(to: 8)),
                pageScore,
              );
              return For.of(
                _pageGens
                    .map(
                      (p) => If(
                        score & p.index,
                        then: p.clear(),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ];
}

enum GuiContainer {
  dropper,
  chest,
  enderchest,
  inventory,
  minecart,
  hopper,
}
