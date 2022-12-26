import 'package:bar_commande/models/item.dart';
import 'package:bar_commande/pages/administrator_folder/item_edit/item_editor_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ItemListEditorWidget extends StatelessWidget {
  const ItemListEditorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Item').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child:CircularProgressIndicator(),
            );
          } else {
            var snap = snapshot.data!.docs;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snap.length,
                itemBuilder: (context, int index) {
                  String id = snap[index].id; 
                  String name = snap[index]['name'];
                      var price = snap[index]['price'];
                      bool isFood = snap[index]['isFood'];
                      bool isAvailable = snap[index]['available'];
                  return ItemEditorWidget(Item.update(id, name, price.toDouble(), isFood, isAvailable));
                });
          }
        });
  }
}