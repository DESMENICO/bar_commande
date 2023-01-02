import 'package:flutter/material.dart';

import '../../models/item.dart';

class ItemMenuWidget extends StatelessWidget {
  final Item _item;
  const ItemMenuWidget(this._item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      child: Row(
        children: [
          Text(_item.name, style: const TextStyle(fontSize: 25)),
          const Spacer(),
          Text(
            "${_item.price} €",
            style: const TextStyle(fontSize: 25),
          )
        ],
      ),
    );
  }
}
