import 'package:bar_commande/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../models/item.dart';
import '../models/order.dart';

class KitchenSummary extends StatelessWidget {
  Order order;
  KitchenSummary(this.order, {super.key});
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
  SummaryItem(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("CurrentOrder")
          .doc(order.id)
          .collection("Item")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        } else {
          var itemList = snapshot.data!.docs;
          order.itemList = [];
          for (int i = 0; i < itemList.length; i++) {
            var name = itemList[i]['name'];
            var price = itemList[i]['price'];
            var isFood = itemList[i]['isFood'];
            var available = itemList[i]['available'];
            order.addItem(Item(name, price, isFood, available));
          }
          Tuple2 itemSummary = order.getItemListSummary();
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

class ItemWidget extends StatelessWidget {
  Item item;
  int count;
  ItemWidget(this.item, this.count, {super.key});
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

class SummaryOrderBottombar extends StatefulWidget {
  Order order;
  DataBase dataBase = DataBase();
  SummaryOrderBottombar(this.order);

  @override
  State<SummaryOrderBottombar> createState() => _SummaryOrderBottombarState();
}

class _SummaryOrderBottombarState extends State<SummaryOrderBottombar> {
  _SummaryOrderBottombarState();

  void deleteOrderFromScreenWithDelay() async{
      Future.delayed(const Duration(seconds: 5),((() async{
      widget.order.isOnScreen = false;
      await widget.dataBase.updateOrder(widget.order);
      if(widget.order.finish){
      await widget.dataBase.deleteCurrentOrder(widget.order);
    }
    })));
    
  }

  void _setDrinkFinish() async {
    setState(() {
      widget.order.containDrink = false;
    });
    widget.order.removeDrinkItem();
        
    if (!widget.order.containDrink && !widget.order.containFood) {
      widget.order.finish = true;
      await widget.dataBase.deleteCurrentOrder(widget.order);
    }
     await widget.dataBase.removeFinishedOrder(widget.order);
    //widget.order.itemList = await widget.dataBase.getItemList(widget.order.id);
    if (!widget.order.containFood) {
      Navigator.pop(context);
    }
    await widget.dataBase.updateItemList(widget.order);
    await widget.dataBase.updateOrder(widget.order);
  }

  

  void _setFoodFinish() async {
    setState(() {
      widget.order.containFood = false;
    });
    widget.order.removeFoodItem();    
    //await widget.dataBase.addFinishedOrder(widget.order);
    //await widget.dataBase.removeFinishedOrder(widget.order);
    widget.order.isOnScreen = true;
    if (!widget.order.containDrink && !widget.order.containFood) {
      widget.order.finish = true;
      
    }
    await widget.dataBase.updateItemList(widget.order);
    await widget.dataBase.updateOrder(widget.order);
    if (!widget.order.containDrink) {
      Navigator.pop(context);
    }
    deleteOrderFromScreenWithDelay();
    
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Visibility(
          visible: widget.order.containFood,
          child: ElevatedButton(
            onPressed: _setFoodFinish,
            child: const Text(
              "Servir Nourriture",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Visibility(
          visible: widget.order.containDrink,
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
