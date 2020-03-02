# objD Gui Extension

The gui package for objD allows you to built any gui, simple or very complex, just by defining a few properties. objD does anything else.

This package also has a web interface: https://stevertus.com/tools/gui

Read how to use it [here](https://stevertus.com/article/guiguide)

## Installation

Installing the package is strait forward just add to your existing objD project, objd_gui as dependency in the pubspec.yaml file.

```yaml
objd_gui: 0.0.1
```

Then you can import it with

```dart
import 'package:objd_gui/gui.dart'
```

## GuiModule

The core part of the package is the GuiModule. You can use this in your `modules` list in a pack or include it as usual widget somewhere in case you want to run it conditionally.

For each container type and size there is one constructor: GuiModule.chest, GuiModule.dropper, GuiModule.hopper, GuiModule.enderchest, GuiModule.inventory, GuiModule.minecart and GuiModule.item.

```dart
Pack(
	...,
	main:... // has to be included!
	load:...
	modules: [
		GuiModule.chest(
			Location('-49 56 -36')
			...
		)
	]
)
```

Except GuiModule.item they work quite similarly, they just represent different gui sizes. So for example if you have a 9x3 container(e.g Barrel), the chest constructor would be used. objD does not place any blocks or summon entities, they have to be managed by you.
Depending on the container, the GuiModule also needs the Location of the Block, an Entity to check or an Item, that must be selected to show the Gui.

## GuiPages

Your guis can be seperated in multiple pages. The pages can be switched and display different content or have different functionality. So for each page the entire Gui is built again.

```dart
GuiModule.chest(
		Location('-49 56 -36')
		pages: [
			GuiPage(
				[
					...
				],
				fillEmptySlots: true,
				placeholder: Item(Items.gray_stained_glass_pane)
			)
		]
)
```

Each Page requires a list of GuiSlots, that should be placed in the current Gui. With the `fillEmptySlots` option you can toggle, whether the slots that are not specified should be filled and blocked with either the `placeholder` provided by the page itself or if not available by the placeholder of the GuiModule.

## GuiSlot

The data class GuiSlot actually defines what should happen where. Generally they can be defined as a pair of Item and Slot.
You give the generator the slot to place an item. Simple right?
Well it is a bit more customizable. There are multiple GuiSlot types that do different actions within the gui.

### Placeholder

We already discussed the `Placeholder`. This is a simple item that blocks the corresponding slot, can't be taken out and has no major actions. The placed item is the one specified as `placeholder` by the Module or the current Page. You can override it though by specifying an optional item.

```dart
GuiPage(
	[
		Placeholder(
			slot: Slot.chest(2,1),
			item: Item(Items.black_stained_glass_pane), // overwritten the lame gray one
		)
	],
)
```

### EmptySlot

The `EmptySlot` just makes sure that the specified slot is not filled or cleared at all so the user could put an item in there(This is only necessary when you use fillEmptySlots).

```dart
EmptySlot(
	slot: Slot.chest(2,2),
)
```

### Interactive

With this type you can literally do everything. In its core it is just an clickable item in your Gui. You can optionally specify a set of Widgets(actions) that should run when the item has been clicked. Additionally you can also give it a `countScore` that modifies the count of the item(Great for option gui, sliders, displaying data, etc). The Item is required here.

```dart
Interactive(
	Item(Items.stone)
	slot: Slot.chest(2,5),
	actions: [
		Log('clicked stone'),
	],
	countScore: Score(Entity.Player(), 'custom_score'),
)
```

### ChangePage

The last type is `ChangePage`. Like the name states, this is a simple way to change the current page. As usual you define an item and slot and additionally the index of the page you want to navigate to(starting with 1).

```dart
ChangePage(
	2
	Item(Items.arrow),
	slot: Slot.chest(3,9),
)
```

To make it simpler to navigate back and forth, you can also use ChangePage.next or ChangePage.prev:

```dart
ChangePage.next(
	Item(Items.arrow),
	slot: Slot.chest(3,9),
)
ChangePage.prev(
	Item(Items.arrow),
	slot: Slot.chest(3,1),
)
```

This Action also warns before hand you in case you want to navigate to a page that does not exist.

## Filling the Gui dynamically

For now we always set the slot together with the GuiSlot and fixed the position. But with the power of objD and generation, you can also leave the slot empty and it will figure out the first slot that is not occupied and fill up the gui left to right.

So if we were to define another page with:

```dart
GuiPage(
	[
		ChangePage.prev(
			Item(Items.arrow),
		),
		Interactive(
			Item(Items.apple)
			actions: [
				Log('MY Nice Apple'),
			],
		),
		EmptySlot(
			slot: Slot.chest(1,2),
		),
	],
	fillEmptySlots: true,
)
```

It fills the Gui like that:

![](https://prismic-io.s3.amazonaws.com/stevertuscom/8b15f8e9-f8ff-4030-b7b2-2cbf4ea49a67_2020-02-16_13.00.05.png)

Notice how the EmptySlot, that has a fixed position, is skipped with filling the gui.

## Integrating the Gui into your datapack

Well for now we just learned how to build multiple pages, interact with items and fill the rest with placeholders. But everything was in this one static chest at one location. How can you customize this and use it together with your datapack?
The answer is fairly simple. The GuiModule is an Widget as well. This means that you can use it wherever you want, not just as a module.
Let's say we want to apply the gui to every chest, that we marked with an area effect cloud.

In our main File we can just include our module like that:

```dart
File(
	'main',
	child: Execute.at(
		Entity(type: Entities.area_effect_cloud, tags: ['custom_gui_location']),
		children: [
			GuiModule.chest(
                Location.here(),
				...
			)
		]
	)
)
```

This ensures that the code for the gui is ran at all the locations an AEC is alive.

To further mess with the internal logic and integrating it into your datapack, you can also change the used scoreboards. The Module only uses 1-2 scoreboards, both store values per player basis.

```dart
GuiModule.chest(
	...,
	countScore: 'my_count',
	pageScore: 'my_page',
)
```

The `countScore` is used to check whether items in the Gui have changed(in case someone clicked on an item) by counting all items and comparing it to the ones before.

The `pageScore` holds the state of the current page(index). You can also manipulate this score to change the Gui Page programmatically.

## GlobalSlots

With the `globalSlots` property on the Module you can easily define Slots once that should appear on every page(e.g submenues, pagination).
So let's do that with our navigation arrows.

```dart
GuiModule.chest(
	...,
	globalSlots: [
		ChangePage.prev(
			Item(Items.arrow),
			slot: Slot.chest(3,1),
		)
		ChangePage.next(
			Item(Items.arrow),
			slot: Slot.chest(3,9),
		)
	]
)
```

## Entire Example

So far we built a gui with two pages, the ability to navigate between them, trigger actions and dynamically set the slots.
You can find the entire example code (here)[].

## Bind Gui To An Item

objd_gui also includes the feature to show and hide the gui(as a minecart) if the player holds a specific item in their hand. So this acts kind of like a game menu or portable menu. Therefore a few additional arguments can be specified.

```dart
GuiModule.item(
	Item(Items.stone),
	alwaysActive: false,
	name: TextComponent('my awesome gui'),
)
```

The Item is obviously the item that you want to detect, you can also provide nbt or custommodels here.
With the alwaysActive option you can toggle whether the Gui should appear always in front of the player or just in the floor when you look straight down (you can also provide a custom location with `offset`).
And you can give the corresponding Minecart a custom name that will be displayed in the gui.

## Thanks for using objD!

I hope you can create awesome things with this api and all the use cases are supported. However if you encounter a bug or have a problem, contact me via Discord(https://discord.gg/vnPsgfc) or email me [contact@stevertus.com](mailto://contact@stevertus.com)
