import 'package:bar_commande/bloc/order_events.dart';
import 'package:bar_commande/bloc/order_states.dart';
import 'package:bar_commande/pages/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/order_bloc.dart';
import '../models/item.dart';
import "../models/order.dart" as models;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class OrderPage extends StatefulWidget {

  final User user;

  const OrderPage(this.user, {super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late models.Order order;
  @override
  void initState() {
    super.initState();
    order = models.Order("Nouveau Client");
    order.sellerId = widget.user.name;
    context.read<OrderBloc>().add(AddOrderEvent(order));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc,OrderState>(
      builder:((context, state) {
        order = state.orders.last;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Commande"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon:  const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.read<OrderBloc>().add(RemoveOrderEvent(order));
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(children: [
        ClientNameForms(order),
        Expanded(child: ItemListWidget(order)),
        OrderBottomBar(order,widget.user)
      ]),
    );
      }) ,
    );
  }
}

class ClientNameForms extends StatefulWidget {
  final models.Order order;
  const ClientNameForms(this.order, {super.key});

  @override
  State<ClientNameForms> createState() => _ClientNameFormsState();
}

class _ClientNameFormsState extends State<ClientNameForms> {

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
          widget.order.customer = value;
          context.read<OrderBloc>().add(UpdateOrderEvent(widget.order));
        },
      ),
      ),
      );
      },
    
    );
  }
}

class ItemListWidget extends StatefulWidget {
  final models.Order order;
  const ItemListWidget( this.order, {super.key});
  @override
  State<ItemListWidget> createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Item').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child:  CircularProgressIndicator(),
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
                  Item item = Item(name, price.toDouble(), isFood, isAvailable);
                  return ItemWidget(
                      item,widget.order,key: ValueKey(item));
                });
          }
        });
  }
}

class ItemWidget extends StatefulWidget {
  final Item item;
  final models.Order order;

  const ItemWidget(this.item, this.order, {super.key});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();//item);
}

class _ItemWidgetState extends State<ItemWidget> {
 // Item item;
  _ItemWidgetState();//this.item);

  void _incrementItemNumber() {
    widget.order.addItem(widget.item);
    context.read<OrderBloc>().add(UpdateOrderEvent(widget.order));
    }

  void _decrementItemNumber() {
      widget.order.removeItem(widget.item);
    setState(() {
      context.read<OrderBloc>().add(UpdateOrderEvent(widget.order));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.item.isAvailable,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Card(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.item.name,
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
                    "${widget.item.price}€",
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
                      state.orders.last.getItemNumber(widget.item).toString(),
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
      ),
    );
  }
}

class OrderBottomBar extends StatefulWidget {
  models.Order order;
  final User user;
  OrderBottomBar(this.order,this.user, {super.key});
  @override
  State<OrderBottomBar> createState() => _OrderBottomBar();
}

class _OrderBottomBar extends State<OrderBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrderSummary(widget.order),
                ),
              );
              widget.order = models.Order("Nouveau Client");//PBB??????????
              widget.order.sellerId = widget.user.name;
              context.read<OrderBloc>().add(AddOrderEvent(widget.order));//????????
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
