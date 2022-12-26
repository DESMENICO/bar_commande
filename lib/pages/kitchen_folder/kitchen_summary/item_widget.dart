import 'package:bar_commande/models/item.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final Item item;
  final int count;
  const ItemWidget(this.item, this.count, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item.name,
              style:
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          Text(count.toString(), style: const TextStyle(fontSize: 25))
        ],
      ),
    );
  }
}