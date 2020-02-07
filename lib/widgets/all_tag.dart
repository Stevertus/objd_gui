import 'dart:convert';

import 'package:objd/core.dart';

class TagAll extends Widget {
  @override
  Widget generate(Context context) {
    return RawFile(
      'tags/items/all.json',
      json.encode(
        {
          'values': Items.all.map((i) => i.toString()).toList(),
        },
      ),
    );
  }
}
