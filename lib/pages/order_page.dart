import 'dart:math';
import 'package:bar_commande/bloc/item_events.dart';
import 'package:bar_commande/bloc/order_events.dart';
import 'package:bar_commande/bloc/order_states.dart';
import 'package:bar_commande/pages/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/item_bloc.dart';
import '../bloc/item_states.dart';
import '../bloc/order_bloc.dart';
import '../models/item.dart';
import "../models/order.dart" as Models;
import 'package:cloud_firestore/cloud_firestore.dart';



class OrderPage extends StatefulWidget{
  ItemBloc itemBloc;
  OrderBloc orderBloc;
  late Models.Order order;
  OrderPage(this.itemBloc,this.orderBloc,{super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

 

  @override
  void initState() {
    super.initState();
    widget.order = Models.Order("Nouveau Client");
    context.read<OrderBloc>().add(AddOrderEvent(widget.order));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Commande")),
      body: Column(
        children: [clientNameForms(widget.order),
        Expanded(child: itemListWidget(widget.orderBloc,widget.order)),
        orderBottomBar(widget.order)     
        ]),
    );
  }
}

class clientNameForms extends StatefulWidget{
  late Models.Order order;
  clientNameForms(this.order,{super.key});

  @override
  State<clientNameForms> createState() => _client_name_forms_state();

}

class _client_name_forms_state extends State<clientNameForms>{


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
          onChanged: (value) {if(value != null){widget.order.customer = value;
          context.read<OrderBloc>().add(UpdateOrderEvent(widget.order));}},
          ),
          
      )
    );
  }
}


class itemListWidget extends StatefulWidget{
  OrderBloc orderBloc;
  Models.Order order;
  itemListWidget(this.orderBloc,this.order);
  @override
  State<itemListWidget> createState() => _itemListWidgetState();
  

}

class _itemListWidgetState extends State<itemListWidget>{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Item').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
       if(!snapshot.hasData){
        return Center(
          child: CircularProgressIndicator(),
        );
       }
        return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context , int index){
                  String name = snapshot.data!.docs[index]['name'];
                  double price = snapshot.data!.docs[index]['price'];
                  bool isFood = snapshot.data!.docs[index]['isFood'];
                  bool isAvailable = snapshot.data!.docs[index]['available'];
                  return ItemWidget(Item(name,price,isFood,isAvailable),widget.order);
                });
          }
        );
  }
}


class ItemWidget extends StatefulWidget{
  Item item;
  Models.Order order;

  ItemWidget(this.item, this.order,{super.key});
  
  @override
  State<ItemWidget> createState() => _itemWidgetState(item);
}


class _itemWidgetState extends State<ItemWidget>{
Item item;
_itemWidgetState(this.item);

  void _incrementItemNumber() {
    setState(() {
      widget.order.addItem(item);
      context.read<OrderBloc>().add(UpdateOrderEvent(widget.order));
    });
  }
  void _decrementItemNumber() {
    setState(() {
      widget.order.removeItem(item);
      context.read<OrderBloc>().add(UpdateOrderEvent(widget.order));
    });
  }

  @override
  Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.symmetric(horizontal:8.0),
     child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(item.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: const Text("///",
                style: TextStyle(
                  fontSize: 12,
                 fontWeight: FontWeight.bold,
                ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text("${item.price}€",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
              ),
            ),
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
                child: Text(widget.order.getItemNumber(item).toString(),   
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
  Models.Order order;
  orderBottomBar(this.order, {super.key});
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
                    builder: (context) => OrderSummary(widget.order),
                  ),);

           },
          child: const Text("Total",
          style: TextStyle(
            fontSize:20,
            fontWeight: FontWeight.w400
          ),
          ),
          ), 
          BlocBuilder<OrderBloc,OrderState>(builder: (context,state) => Text("${widget.order.totalPrice}€",style: const TextStyle(fontSize:20,fontWeight: FontWeight.w400),
            ),)
        ],),
    );
  }

}
