import 'package:bar_commande/pages/kitchen_summary_page.dart';
import 'package:bar_commande/services/firestore_item_collection.dart';
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
  final DataBase dataBase = DataBase();
  List<Order> orderList = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('CurrentOrder').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)  {
          
          if (!snapshot.hasData) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          } else {

            var snap = snapshot.data!.docs;
            orderList = [];
            for(int i = 0; i < snap.length;i++){
                  var customer = snap[i]['customer'];
                  var drinkFinish = snap[i]['containDrink'];
                  var foodFinish = snap[i]['containFood'];
                  var id = snap[i]['id'];
                  double totalPrice = snap[i]['totalPrice'];
                  orderList.add(Order.kitchen(customer,drinkFinish,foodFinish,id,totalPrice));
            }
           
            return ListView.builder(
                shrinkWrap: true,
                itemCount: orderList.length,
                itemBuilder: (context, int index) {
                  /*var customer = snap[index]['customer'];
                  var drinkFinish = snap[index]['containDrink'];
                  var foodFinish = snap[index]['containFood'];
                  var id = snap[index]['id'];
                  var totalPrice = snap[index]['totalPrice'];
                  late Order order =Order.kitchen(customer, drinkFinish, foodFinish, id, totalPrice.toDouble());  */

                  return OrderWidget(orderList[index]);
                  });
          }
        });
  }
}

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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Visibility(
                      visible: widget.order.containDrink,
                      child: const Icon(Icons.local_bar)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Visibility(
                      visible: widget.order.containFood,
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
