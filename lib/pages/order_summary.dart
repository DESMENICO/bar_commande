import 'package:bar_commande/services/firestore_service.dart';
import 'package:flutter/material.dart';

import '../models/item.dart';
import '../models/order.dart';

class OrderSummary extends StatelessWidget {
  final Order order;
  const OrderSummary(this.order, {super.key});
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
  final Order order;
  final List<Item> itemUsed = [];
  SummaryItem(this.order, {super.key});

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

              Item currentItem = order.itemList[index];
              if (!order.isInsideAList(currentItem, itemUsed)) {
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
  final Item item;
  final int count;
  const ItemWidget(this.item,this.count ,{super.key});
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
  final Order order;

  const SummaryOrderBottombar(this.order, {super.key});

  @override
  State<SummaryOrderBottombar> createState() => _SummaryOrderBottombarState();
}

class _SummaryOrderBottombarState extends State<SummaryOrderBottombar> {
  bool isPaid = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Visibility(
          visible: !isPaid,
          child: ElevatedButton(
            onPressed: () {
              setState(() { 
                  isPaid =true;
              });
                     },
            child: Text(
              "Payer : ${widget.order.totalPrice}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Visibility(
          visible: isPaid,
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
