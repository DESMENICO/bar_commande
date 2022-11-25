import 'dart:math';
import 'package:bar_commande/bloc/item_events.dart';
import 'package:bar_commande/bloc/order_events.dart';
import 'package:bar_commande/bloc/order_states.dart';
import 'package:bar_commande/pages/order_summary.dart';
import 'package:bar_commande/services/FireStore_Item_Collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/item_bloc.dart';
import '../bloc/item_states.dart';
import '../bloc/order_bloc.dart';
import '../models/item.dart';
import "../models/order.dart" as Models;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_item_collection.dart';

class OrderPage extends StatefulWidget {
  ItemBloc itemBloc;
  OrderBloc orderBloc;
  late Models.Order order;
  OrderPage(this.itemBloc, this.orderBloc, {super.key});

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
    return BlocBuilder<OrderBloc,OrderState>(
      builder:((context, state) {
        widget.order = state.orders.last;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Commande"),
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.read<OrderBloc>().add(RemoveOrderEvent(widget.order));
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(children: [
        clientNameForms(widget.order),
        Expanded(child: itemListWidget(widget.orderBloc, widget.order)),
        orderBottomBar(widget.order)
      ]),
    );
      }) ,
    );
  }
}

class clientNameForms extends StatefulWidget {
  late Models.Order order;
  clientNameForms(this.order, {super.key});

  @override
  State<clientNameForms> createState() => _client_name_forms_state();
}

class _client_name_forms_state extends State<clientNameForms> {

  final _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc,OrderState>(
      builder: (context, state) {
        if(widget.order.customer == "Nouveau Client"){
          _controller.clear();
        }
    return Form(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: _controller,
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
        onChanged: (value) {
          if (value != null) {
            widget.order.customer = value;
            context.read<OrderBloc>().add(UpdateOrderEvent(widget.order));
          }
        },
      ),
      ),
      );
      },
    
    );
  }
}

class itemListWidget extends StatefulWidget {
  OrderBloc orderBloc;
  Models.Order order;
  itemListWidget(this.orderBloc, this.order);
  @override
  State<itemListWidget> createState() => _itemListWidgetState();
}

class _itemListWidgetState extends State<itemListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Item').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print(snapshot.connectionState);
          if (!snapshot.hasData) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          } else {
            var snap = snapshot.data!.docs;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snap.length,
                itemBuilder: (context, int index) {
                  String name = snap[index]['name'];
                  var price = snap[index]['price'];
                  bool isFood = snap[index]['isFood'];
                  bool isAvailable = snap[index]['available'];
                  return ItemWidget(
                      Item(name, price.toDouble(), isFood, isAvailable),
                      widget.order);
                });
          }
        });
  }
}

class ItemWidget extends StatefulWidget {
  Item item;
  Models.Order order;

  ItemWidget(this.item, this.order, {super.key});

  @override
  State<ItemWidget> createState() => _itemWidgetState(item);
}

class _itemWidgetState extends State<ItemWidget> {
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Card(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                item.name,
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
                  "${item.price}€",
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
                      borderRadius: BorderRadius.circular(50.0)),
                ),
                child: const Text(
                  "-",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) => Text(
                    state.orders.last.getItemNumber(item).toString(),
                    //widget.order.getItemNumber(item).toString(),
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ),
              ElevatedButton(
                onPressed: _incrementItemNumber,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                ),
                child: const Text(
                  "+",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

class orderBottomBar extends StatefulWidget {
  Models.Order order;
  orderBottomBar(this.order, {super.key});
  @override
  State<orderBottomBar> createState() => _orderBottomBar();
}

class _orderBottomBar extends State<orderBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () async {
              var response = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrderSummary(widget.order),
                ),
              );
              widget.order = Models.Order("Nouveau Client");
              context.read<OrderBloc>().add(AddOrderEvent(widget.order));
            },
            child: const Text(
              "Total",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) => Text(
              "${state.orders.last.totalPrice}€",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }
}
