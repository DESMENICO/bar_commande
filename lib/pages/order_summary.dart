import 'package:bar_commande/services/firestore_item_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/material.dart';

import '../models/item.dart';
import '../models/order.dart';

class OrderSummary extends StatelessWidget {
  Order order;
  OrderSummary(this.order, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Commande de ${order.customer}"),
      ),
      body: Column(children: [
        Expanded(child: SummaryItem(order)),
        SummaryOrderBottombar(order)
      ]),
    );
  }
}

class SummaryItem extends StatelessWidget {
  Order order;
  List<Item> itemUsed = [];
  SummaryItem(this.order);

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
            itemCount: order.itemList.length,
            itemBuilder: (context, int index) {
              List<Item> list = order.itemList;
              Item currentItem = order.itemList[index];
              if (order.getItemNumber(list[index]) != 0 && !order.isInsideAList(index, itemUsed)) {
                itemUsed.add(currentItem);
                return ItemWidget(currentItem,order.getItemNumber(currentItem));
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}


class ItemWidget extends StatelessWidget {
  Item item;
  int count;
  ItemWidget(this.item,this.count ,{super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item.name,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          Text(count.toString(), style: const TextStyle(fontSize: 25))
        ],
      ),
    );
  }
}

class SummaryOrderBottombar extends StatefulWidget {
  Order order;
  bool isPaid = false;
  SummaryOrderBottombar(this.order);

  @override
  State<SummaryOrderBottombar> createState() => _SummaryOrderBottombarState();
}

class _SummaryOrderBottombarState extends State<SummaryOrderBottombar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Visibility(
          visible: !widget.isPaid,
          child: ElevatedButton(
            onPressed: () {
              setState(() { 
                  widget.isPaid =true;
              });
                     },
            child: Text(
              "Payer : ${widget.order.totalPrice}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Visibility(
          visible: widget.isPaid,
          child: ElevatedButton(
            onPressed: () async {
              DataBase database = DataBase();
              widget.order.checkFoodAndDrink();
              await database.addCurrentOrder(widget.order);
              await database.addOrder(widget.order);
              Navigator.pop(context,Order("Nouveau Client"));
            },
            child: const Text(
              "Envoyer en cuisine",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        )
      ]),
    );
  }
}
