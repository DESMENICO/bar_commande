import 'dart:math';
import 'package:flutter/material.dart';
import '../models/item.dart';
import '../models/order.dart';



 Order commande = Order("Hello", "Mathis");

class OrderPage extends StatelessWidget{
  const OrderPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Commande")),
      body: Column(
        children: [clientNameForms(),
        itemListWidget()        
        ]),
    );
  }
}

class clientNameForms extends StatefulWidget{
  @override
  State<clientNameForms> createState() => _clientNameFormsState();

}

class _clientNameFormsState extends State<clientNameForms>{
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Entrer le nom du client',
            icon: Icon(Icons.person),
          ),
          validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrer un nom de client svp';
                  }
                  return null;
                },
          ),
      )
    );
  }
}


class itemListWidget extends StatefulWidget{
  @override
  State<itemListWidget> createState() => _itemListWidgetState();
  

}

class _itemListWidgetState extends State<itemListWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (_, int index){
          return ItemWidget(commande.itemList[index]);
        }),
    );
  }
}


class ItemWidget extends StatefulWidget{
  Item item;

  ItemWidget(this.item,{super.key});
  
  @override
  State<ItemWidget> createState() => _itemWidgetState(item);
}


class _itemWidgetState extends State<ItemWidget>{
Item item;

_itemWidgetState(this.item);

  @override
  Widget build(BuildContext context) {
   return Row(
    children: [
      Column(
        children: [
          Text(item.name),
          Text(item.description)
        ],
      ),
      ElevatedButton(
        onPressed: () {},
        child: const Text("-")
        ),
      const Text("0"),
      ElevatedButton(
        onPressed: () {},
        child: const Text("+")
        ),
    ]);
  }

} 