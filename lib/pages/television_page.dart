import 'dart:async';

import 'package:bar_commande/models/order.dart';
import 'package:bar_commande/pages/order_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/item.dart';

class TelevisionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(children: <Widget>[
      Expanded(child: Card(child: ItemListMenuWidget())),
<<<<<<< HEAD
      //Expanded(child: OrderReadyWidget()),
=======
     // Expanded(child: OrderReadyWidget()),
>>>>>>> b0589b38468763ac70229aaff1c05b1aaa55a829
    ]));
  }
}

/*class OrderReadyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ,
      builder: (context, snapshot) {
        
      }
    );
  }
}*/

class ItemListMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Item').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          var snap = snapshot.data!.docs;
          List<Item> itemList = [];
          for (int i = 0; i < snap.length; i++) {
            String name = snap[i]['name'];
            var price = snap[i]['price'];
            bool isFood = snap[i]['isFood'];
            bool isAvailable = snap[i]['available'];
            Item item = Item(name, price.toDouble(), isFood, isAvailable);
            itemList.add(item);
          }

          return Column(
            children: [
              const Text(
                'Boisson : ',
                style: TextStyle(fontSize: 45),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: itemList.length,
                  itemBuilder: (context, int index) {
                    if (!itemList[index].isFood) {
                      return itemMenuWidget(itemList[index]);
                    }
                    return Container();
                  }),
              const Text(
                "Nourriture : ",
                style: TextStyle(fontSize: 45),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: itemList.length,
                  itemBuilder: (context, int index) {
                    if (itemList[index].isFood) {
                      return itemMenuWidget(itemList[index]);
                    }
                    return Container();
                  }),
            ],
          );
        }
      },
    );
  }
}

class itemMenuWidget extends StatelessWidget {
  final Item item;
  const itemMenuWidget(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      child: Row(
        children: [
          Text(item.name, style: TextStyle(fontSize: 25)),
          const Spacer(),
          Text(
            "${item.price} €",
            style: TextStyle(fontSize: 25),
          )
        ],
      ),
    );
  }
}
