import 'package:bar_commande/pages/kitchen/kitchen_page/order_widget.dart';
import 'package:bar_commande/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../bloc/item_bloc.dart';
import '../../../bloc/order_bloc.dart';
import '../../../models/order.dart';

class KitchenPage extends StatelessWidget {
  final ItemBloc itemBloc;
  final OrderBloc orderBloc;
  const KitchenPage(this.itemBloc, this.orderBloc, {super.key});
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
  final ItemBloc itemBloc;
  final OrderBloc orderBloc;
  const OrderListWidget(this.itemBloc, this.orderBloc, {super.key});
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
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var snap = snapshot.data!.docs;
            orderList = [];
            for (int i = 0; i < snap.length; i++) {
              var customer = snap[i]['customer'];
              var drinkFinish = snap[i]['containDrink'];
              var foodFinish = snap[i]['containFood'];
              var id = snap[i]['id'];
              var totalPrice = snap[i]['totalPrice'];
              Timestamp dateTime = snap[i]['date'];
              DateTime date =
                  DateTime.fromMillisecondsSinceEpoch(dateTime.seconds * 1000);
              orderList.add(Order.kitchen(
                  customer, drinkFinish, foodFinish, id, totalPrice.toDouble(), date));
            }
            orderList
                .sort((order1, order2) => order1.date.compareTo(order2.date));
            return ListView.builder(
                shrinkWrap: true,
                itemCount: orderList.length,
                itemBuilder: (context, int index) {
                  if (!orderList[index].isOnScreen) {
                    return OrderWidget(orderList[index],
                        key: ValueKey(orderList[index]));
                  } else {
                    return Container();
                  }
                });
          }
        });
  }
}

