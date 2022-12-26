import 'package:bar_commande/models/item.dart';
import 'package:bar_commande/pages/television_folder/item_menu_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemListMenuWidget extends StatelessWidget {
  const ItemListMenuWidget({super.key});

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
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: const Color.fromARGB(255, 0, 151, 144),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Boisson : ',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: itemList.length,
                  itemBuilder: (context, int index) {
                    if (!itemList[index].isFood &&
                        itemList[index].isAvailable) {
                      return ItemMenuWidget(itemList[index]);
                    }
                    return Container();
                  }),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: const Color.fromARGB(255, 0, 151, 144),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Nourriture/Snack : ',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: itemList.length,
                  itemBuilder: (context, int index) {
                    if (itemList[index].isFood && itemList[index].isAvailable) {
                      return ItemMenuWidget(itemList[index]);
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
