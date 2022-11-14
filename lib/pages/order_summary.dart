import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/item.dart';
import '../models/order.dart';

Order commande = Order("czecze","onzoeczc");


class OrderSummary extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recapitulatif des commandes"),),
      body: Column(children: [
        Text(commande.customer),
        SummaryItem()
      ]),
    );

  }
}


class SummaryItem extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
    itemCount: commande.itemList.length,
    itemBuilder: (context , int index){
          return ItemWidget(commande.itemList[index]);
      }
    );
  }
    
  }

  class ItemWidget extends StatelessWidget{
    Item item;
    ItemWidget(this.item, {super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(item.name),
        Text("nombre de commande")      
      ],
    );
  }

  }
