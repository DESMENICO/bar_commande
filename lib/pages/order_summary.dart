import 'package:flutter/material.dart';

import '../models/item.dart';
import '../models/order.dart';

class OrderSummary extends StatelessWidget {
  Order commande;
  OrderSummary(this.commande, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Commande de ${commande.customer}"),
      ),
      body: Column(children: [
        Expanded(child: SummaryItem(commande)),
        SummaryOrderBottombar(commande)
      ]),
    );
  }
}

class SummaryItem extends StatelessWidget {
  Order commande;
  SummaryItem(this.commande);

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
            itemCount: commande.itemList.length,
            itemBuilder: (context, int index) {
              if (commande.getItemNumber(commande.getItemInList(index)) != 0) {
                return ItemWidget(commande.itemList[index],commande.getItemNumber(commande.getItemInList(index)));
              } else {
                return Row();
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
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          Text(count.toString(), style: const TextStyle(fontSize: 25))
        ],
      ),
    );
  }
}

class SummaryOrderBottombar extends StatelessWidget {
  Order order;
  SummaryOrderBottombar(this.order);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        ElevatedButton(
          onPressed: () async {},
          child: Text(
            "Payer : ${order.totalPrice}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ),
        ElevatedButton(
          onPressed: () async {},
          child: const Text(
            "Envoyer en cuisine",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        )
      ]),
    );
  }
}
