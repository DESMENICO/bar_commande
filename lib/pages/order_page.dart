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
import '../models/order.dart';



 late Order order;
List<Item> items = List.generate(
        10,
        (index) => Item("Item${Random().nextInt(10000)}", Random().nextDouble() * 2.5, false, "Ceci est une description", true));
 Order commande = Order("Mathis");

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
    super.initState();
    order = Order("Nouveau client");
    context.read<OrderBloc>().add(AddOrderEvent(order));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Commande")),
      body: Column(
        children: [const clientNameForms(),
        Expanded(child: itemListWidget(widget.orderBloc)),
        orderBottomBar()     
        ]),
    );
  }
}

class clientNameForms extends StatefulWidget{
  const clientNameForms({super.key});

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
      child: BlocBuilder<ItemBloc,ItemState>(
        builder: (context, state) {
          print(state);
          return ListView.builder(
              shrinkWrap: true,
              itemCount: state.items.length,
              itemBuilder: (context , int index){
                return ItemWidget(state.items[index]);
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
      order.addItem(item);
      context.read<OrderBloc>().add(UpdateOrderEvent(order));
    });
  }
  void _decrementItemNumber() {
    setState(() {
      order.removeItem(item);
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
                child: Text(item.description,
                style: const TextStyle(
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
<<<<<<< HEAD
              padding: const EdgeInsets.only(left: 5.0,right: 5.0),
              child: Text("${item.price}€",
=======
              padding: const EdgeInsets.only(left: 5.0),
              child: Text("${item.name} ${item.price.toStringAsPrecision(2)}€",
>>>>>>> 4b6c4e5afbdab7095e745d09db57b2b5060eeb7d
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
                child: Text(order.getItemNumber(item).toString(),   
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
<<<<<<< HEAD
          BlocBuilder<OrderBloc,OrderState>(builder: (context,state) => Text("${order.totalPrice}€",style: const TextStyle(fontSize:20,fontWeight: FontWeight.w400),
=======
          BlocBuilder<OrderBloc,OrderState>(builder: (context,state) => Text("${order.totalPrice.toStringAsPrecision(2)}€",style: const TextStyle(fontSize:20,fontWeight: FontWeight.w400),
>>>>>>> 4b6c4e5afbdab7095e745d09db57b2b5060eeb7d
            ),)
        ],),
    );
  }

}
