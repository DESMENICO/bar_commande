import 'package:bar_commande/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bar_commande/models/order.dart' as models;
import 'item_widget.dart';

class ItemListWidget extends StatefulWidget {
  final models.Order order;
  const ItemListWidget( this.order, {super.key});
  @override
  State<ItemListWidget> createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Item').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child:  CircularProgressIndicator(),
            );
          } else {
            var snap = snapshot.data!.docs;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snap.length,
                itemBuilder: (context, int index) {
                  String name = snap[index]['name'];
                  var price = snap[index]['price'];
                  bool isFood = snap[index]['isFood'];
                  bool isAvailable = snap[index]['available'];
                  Item item = Item(name, price.toDouble(), isFood, isAvailable);
                  return ItemWidget(
                      item,widget.order,key: ValueKey(item));
                });
          }
        });
  }
}
