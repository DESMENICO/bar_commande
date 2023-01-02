
import 'package:bar_commande/models/item.dart';
import 'package:bar_commande/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'item_widget.dart';


class SummaryItemWidget extends StatelessWidget {
  final Order _order;
  const SummaryItemWidget(this._order, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("CurrentOrder")
          .doc(_order.id)
          .collection("Item")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          var itemList = snapshot.data!.docs;
          _order.itemList = [];
          for (int i = 0; i < itemList.length; i++) {
            var name = itemList[i]['name'];
            var price = itemList[i]['price'];
            var isFood = itemList[i]['isFood'];
            var available = itemList[i]['available'];
            _order.addItem(Item(name, price.toDouble(), isFood, available));
          }
          Tuple2 itemSummary = _order.getItemListSummary();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: itemSummary.item1.length,
                  itemBuilder: (context, int index) {   
                  return ItemWidget(itemSummary.item2[index], itemSummary.item1[index]);
               }),
            ),
          );
        }
      },
    );
  }
}