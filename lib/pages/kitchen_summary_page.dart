import 'package:flutter/material.dart';

import '../models/item.dart';
import '../models/order.dart';

class KitchenSummary extends StatelessWidget {
  Order commande;
  KitchenSummary(this.commande, {super.key});
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
  List<Item> itemUsed = [];
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
              List<Item> list = commande.itemList;
              Item currentItem = commande.getItemInList(index);
              if (commande.getItemNumber(list[index]) != 0 && !commande.isInsideAList(index, itemUsed)) {
                itemUsed.add(currentItem);
                return ItemWidget(currentItem,commande.getItemNumber(currentItem));
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
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          Text(count.toString(), style: const TextStyle(fontSize: 25))
        ],
      ),
    );
  }
}

class SummaryOrderBottombar extends StatefulWidget {
  Order order;
  SummaryOrderBottombar(this.order);

  @override
  State<SummaryOrderBottombar> createState() => _SummaryOrderBottombarState();
}

class _SummaryOrderBottombarState extends State<SummaryOrderBottombar> {
    _SummaryOrderBottombarState();
    void _setDrinkFinish() {
    setState(() {
      widget.order.drinkFinish = true;
    }
    );
    if(widget.order.foodFinish){
      Navigator.pop(context);
    }
    }

    void _setFoodFinish() {
    setState(() {
      widget.order.foodFinish = true;
    }
    );
    if(widget.order.drinkFinish){
      Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Visibility(
          visible: !widget.order.foodFinish,
          child: ElevatedButton(
            onPressed: _setFoodFinish,
            child: const Text(
              "Servir Nourriture",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Visibility(
          visible: !widget.order.drinkFinish,
          child: ElevatedButton(
            onPressed: _setDrinkFinish,
            child: const Text(
              "Servir Boisson",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        )
      ]),
    );
  }
}
