import 'package:bar_commande/pages/kitchen_summary_page.dart';
import 'package:bar_commande/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../bloc/item_bloc.dart';
import '../bloc/order_bloc.dart';
import '../models/order.dart';

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

class OrderWidget extends StatefulWidget {
  final Order order;
  const OrderWidget(this.order, {super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();//order);
}

class _OrderWidgetState extends State<OrderWidget> {
  //Order order;
  _OrderWidgetState();//this.order);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.order.containDrink || widget.order.containFood,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          child: InkWell(
            onTap: () async {
               await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => KitchenSummary(widget.order),
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
                        widget.order.customer,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
