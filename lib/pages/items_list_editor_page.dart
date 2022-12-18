import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firestore_service.dart';
import 'item_editor_page.dart';

class ItemListEditor extends StatefulWidget {
  const ItemListEditor({super.key});

  @override
  State<ItemListEditor> createState() => _ItemListEditorState();
}

class _ItemListEditorState extends State<ItemListEditor> {
  _ItemListEditorState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editeur d'articles"),
      ),
      body: const ItemListEditorWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ItemEditor(Item("Nouvelle article", 0, true, true)),
            ),
          );          
        },
        tooltip: 'Ajouter un article',
        child: const Icon(Icons.add),
      ),
    );
  }
}

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

class ItemEditorWidget extends StatefulWidget {
  final Item item;
  const ItemEditorWidget(this.item, {super.key});

  @override
  State<ItemEditorWidget> createState() => _ItemEditorWidgetState();
}

class _ItemEditorWidgetState extends State<ItemEditorWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ItemEditor(widget.item),
            ),
          );
        },
        child: Card(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.item.name,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    "${widget.item.price}€",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async{
                DataBase database = DataBase();
                    await database.deleteItem(widget.item);
              },
            )
          ]),
        ),
      ),
    );
  }
}
