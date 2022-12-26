import 'package:bar_commande/pages/administrator_folder/item_edit/item_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../models/item.dart';
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




