import 'dart:html';

import 'package:bar_commande/pages/kitchen_summary_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import '../bloc/item_bloc.dart';
import '../bloc/order_bloc.dart';
import '../models/item.dart';
import '../models/order.dart';
import '../models/order_list.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_events.dart';
import '../bloc/order_states.dart';
import 'order_summary.dart';

class KitchenPage extends StatelessWidget {
  ItemBloc itemBloc;
  OrderBloc orderBloc;
  KitchenPage(this.itemBloc, this.orderBloc, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cuisine")),
      body: Column(children: [
        OrderListWidget(itemBloc, orderBloc),
      ]),
    );
  }
}

class OrderListWidget extends StatefulWidget {
  ItemBloc itemBloc;
  OrderBloc orderBloc;
  OrderListWidget(this.itemBloc, this.orderBloc, {super.key});
  @override
  State<OrderListWidget> createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('CurrentOrder').snapshots(),
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
                  var customer = snap[index]['customer'];
                  var drinkFinish = snap[index]['drinkFinish'];
                  var foodFinish = snap[index]['foodFinish'];
                  var id = snap[index]['id'];
                  var totalPrice = snap[index]['totalPrice'];
                  Order order = Order.kitchen(
                      customer, drinkFinish, foodFinish, id, totalPrice);
                  List<Item> itemsList = [];
                  FirebaseFirestore.instance
                      .collection('CurrentOrder')
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                      FirebaseFirestore.instance
                          .doc(doc.id)
                          .collection('Item')
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          var name = doc['name'];
                          var price = doc['price'];
                          var isFood = doc['isFood'];
                          var isAvailable = doc['available'];
                          Item item =
                              Item(name, price.toDouble(), isFood, isAvailable);
                              print(name + " " + price.toString());
                          order.addItem(item);
                        });
                      });
                    });
                  });
                  return OrderWidget(order);
                });
          }
        });
  }
}
/*var query = FirebaseFirestore.instance.collection('CurrentOrder').get();
              for(var doc in query.docs){
                //QuerySnapshot subQuery = await FirebaseFirestore.instance.collection('CurrentOrder').doc(snapshot.data!.docs).collection('Item').get(); 
              }
              //Future<QuerySnapshot<Map<String, dynamic>>> subQuery = FirebaseFirestore.instance.collection('CurrentOrder').doc(snapshot.data!.docs).collection('Item').get(); 
              //DocumentSnapshot itemList = snapshot.data.documents[index];*/

class OrderWidget extends StatefulWidget {
  Order order;

  OrderWidget(this.order, {super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState(order);
}

class _OrderWidgetState extends State<OrderWidget> {
  Order order;
  _OrderWidgetState(this.order);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () async {
          var response = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => KitchenSummary(order),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    order.customer,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Visibility(
                      visible: !widget.order.drinkFinish,
                      child: const Icon(Icons.local_bar)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Visibility(
                      visible: !widget.order.foodFinish,
                      child: const Icon(Icons.local_dining)),
                ),
                /*Text(
                  order.customer,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                )*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}
