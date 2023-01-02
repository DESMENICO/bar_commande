import 'package:bar_commande/models/item.dart';
import 'package:bar_commande/models/order.dart';
import 'package:flutter/material.dart';

import 'item_widget.dart';

class SummaryItem extends StatelessWidget {
  final Order _order;
  final List<Item> _itemUsed = [];
  SummaryItem(this._order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _order.itemList.length,
            itemBuilder: (context, int index) {
              Item currentItem = _order.itemList[index];
              if (!_order.isInsideAList(currentItem, _itemUsed)) {
                _itemUsed.add(currentItem);
                return ItemWidget(
                    currentItem, _order.getItemNumber(currentItem));
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
