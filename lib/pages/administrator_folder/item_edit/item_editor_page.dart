import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/item.dart';
import '../../../services/firestore_service.dart';

class ItemEditor extends StatefulWidget {
  final Item _item;

  const ItemEditor(this._item, {super.key});

  @override
  ItemEditorState createState() {
    return ItemEditorState();
  }
}

class ItemEditorState extends State<ItemEditor> {
  final _formKey = GlobalKey<FormState>();
  bool isFood = false;
  bool isAvailable = false;

  @override
  void initState() {
    super.initState();
    isFood = widget._item.isFood;
    isAvailable= widget._item.isAvailable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edition de  ${widget._item.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                  initialValue: widget._item.name,
                  decoration: const InputDecoration(
                      labelText: "Entrer le nom de l'article",
                      icon: Icon(Icons.article)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entrer un nom d'article svp";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget._item.name = value!;
                  }),
              TextFormField(
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),],
                keyboardType: TextInputType.number,
                initialValue: widget._item.price.toString(),
                decoration: const InputDecoration(
                    labelText: "Entrer le prix de l'article",
                    icon: Icon(Icons.euro)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Entrer un prix svp";
                  }
                  return null;
                },
                onSaved: (value) {
                    widget._item.price = double.parse(value!);
                  }
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.local_dining),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Switch(
                          value: isFood,
                          onChanged: (value) {
                            setState(() {
                              isFood = value;
                            });
                          }),
                    ),
                    const Text('Nourriture'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.check),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Switch(
                          value: isAvailable,
                          onChanged: (value) {
                            setState(() {
                              isAvailable = value;
                            });
                          }),
                    ),
                    const Text('Disponible'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget._item.isFood = isFood;
                    widget._item.isAvailable = isAvailable;
                    DataBase database = DataBase();
                    await database.updateItem(widget._item);
                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                },
                child: const Text("Sauvegarder"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
