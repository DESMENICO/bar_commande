
import 'package:flutter/material.dart';

import '../../../models/item.dart';
import '../../../services/firestore_service.dart';
import 'item_editor_page.dart';


class ItemEditorWidget extends StatefulWidget {
  final Item _item;
  const ItemEditorWidget(this._item, {super.key});

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
              builder: (context) => ItemEditor(widget._item),
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
                  widget._item.name,
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
                    "${widget._item.price}€",
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
                    await database.deleteItem(widget._item);
              },
            )
          ]),
        ),
      ),
    );
  }
}