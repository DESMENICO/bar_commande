import 'dart:html';
import 'dart:math';
import 'package:bar_commande/pages/order_summary.dart';
import 'package:flutter/material.dart';
import '../models/item.dart';
import '../models/order.dart';



 Order commande = Order("Mathis");

class OrderPage extends StatelessWidget{
  const OrderPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Commande")),
      body: Column(
        children: [clientNameForms(),
        Expanded(child: itemListWidget()),
        orderBottomBar()     
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
          onChanged: (value) {if(value != null){commande.customer = value;}},
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
          shrinkWrap: true,
          itemCount: commande.itemList.length,
          itemBuilder: (context , int index){
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

  void _incrementItemNumber() {
    setState(() {
      item.number++;
      commande.totalPrice += item.price;
    });
  }
  void _decrementItemNumber() {
    if(item.number == 0){
      return;
    }
    setState(() {
      item.number--;
      commande.totalPrice -= item.price;
    });
  }

  @override
  Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.symmetric(horizontal:8.0),
     child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text("${item.name} ${item.price}€",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(item.description,
              style: const TextStyle(
                fontSize: 12,
               fontWeight: FontWeight.bold,
              ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: _decrementItemNumber,
              style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)
              ),
              ),
              child: const Text("-",
              style: TextStyle(
                fontSize: 25),
              ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(item.number.toString(),   
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),

            ElevatedButton(
              onPressed: _incrementItemNumber,
              style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)
              ),
              ),
              child: const Text("+",
              style: TextStyle(
                fontSize: 25),
              ),
              ),
          ],
        ),
      ]),
   );
  }
} 


class orderBottomBar extends StatefulWidget{
  @override
  State<orderBottomBar> createState() => _orderBottomBar();
}

class _orderBottomBar extends State<orderBottomBar>{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 7.0),
      child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [ElevatedButton(
          onPressed: () async { 
          var response = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OrderSummary(commande),
                  ),);

           },
          child: const Text("Total",
          style: TextStyle(
            fontSize:20,
            fontWeight: FontWeight.w400
          ),
          ),
          ), 
          Text(commande.totalPrice.toString() + "€",
          style: TextStyle(
            fontSize:20,
            fontWeight: FontWeight.w400
          ),
          )
        ],),
    );
  }

}
