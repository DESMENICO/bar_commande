import 'dart:math';

import 'package:bar_commande/bloc/item_events.dart';
import 'package:bar_commande/bloc/order_events.dart';
import 'package:bar_commande/bloc/order_states.dart';
import 'package:bar_commande/pages/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/item_bloc.dart';
import '../bloc/order_bloc.dart';
import '../models/item.dart';
import '../models/order.dart';



 late Order order;
List<Item> items = List.generate(
        10,
        (index) => Item("Item${Random().nextInt(10000)}", Random().nextDouble() * 2.5, false, "Ceci est une description", true));
 Order commande = Order("Mathis",items);

class OrderPage extends StatefulWidget{
  ItemBloc itemBloc;
  OrderBloc orderBloc;
  OrderPage(this.itemBloc,this.orderBloc,{super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    order = Order("Nouveau client",widget.itemBloc.state.items);
    context.read<OrderBloc>().add(AddOrderEvent(order));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Commande")),
      body: Column(
        children: [clientNameForms(),
        Expanded(child: itemListWidget(widget.orderBloc)),
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
          onChanged: (value) {if(value != null){order.customer = value;
          context.read<OrderBloc>().add(UpdateOrderEvent(order));}},
          ),
          
      )
    );
  }
}


class itemListWidget extends StatefulWidget{
  OrderBloc orderBloc;
  itemListWidget(this.orderBloc);
  @override
  State<itemListWidget> createState() => _itemListWidgetState();
  

}

class _itemListWidgetState extends State<itemListWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: order.itemList.length,
              itemBuilder: (context , int index){
                return ItemWidget(order.itemList[index]);
              });
        }
      ),
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
      order.totalPrice += item.price;
      context.read<ItemBloc>().add(UpdateItemEvent(item));
      context.read<OrderBloc>().add(UpdateOrderEvent(order));
    });
  }
  void _decrementItemNumber() {
    if(item.number == 0){
      return;
    }
    setState(() {
      item.number--;
      order.totalPrice -= item.price;
      context.read<ItemBloc>().add(UpdateItemEvent(item));
      context.read<OrderBloc>().add(UpdateOrderEvent(order));
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
                    builder: (context) => OrderSummary(order),
                  ),);

           },
          child: const Text("Total",
          style: TextStyle(
            fontSize:20,
            fontWeight: FontWeight.w400
          ),
          ),
          ), 
          BlocBuilder<OrderBloc,OrderState>(builder: (context,state) => Text(order.totalPrice.toString() + "€",style: TextStyle(fontSize:20,fontWeight: FontWeight.w400),
            ),)
        ],),
    );
  }

}
