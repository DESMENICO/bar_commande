import 'dart:async';

import 'package:bar_commande/models/order.dart';
import 'package:bar_commande/pages/order_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/item.dart';

class TelevisionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(children: <Widget>[
      Expanded(child: const Card(child: ItemListMenuWidget())),
      Expanded(child: OrderReadyWidget()),
    ]));
  }
}

class OrderFinishedWidget extends StatefulWidget {
  List<Order> orderList;
  OrderFinishedWidget(this.orderList);

  @override
  State<OrderFinishedWidget> createState() => _OrderFinishedWidgetState();
}

class _OrderFinishedWidgetState extends State<OrderFinishedWidget> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: widget.orderList.length,
          itemBuilder: (context, index) {
            if (widget.orderList[index].isOnScreen) {
              return OrderFinishedItemWidget(widget.orderList[index]);
            } else {
              return Container();
            }
          });
    });
  }
}

class OrderFinishedItemWidget extends StatefulWidget {
  Order order;
  OrderFinishedItemWidget(this.order, {super.key});

  @override
  State<OrderFinishedItemWidget> createState() =>
      _OrderFinishedItemWidgetState();
}

class _OrderFinishedItemWidgetState extends State<OrderFinishedItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "La commande de ${widget.order.customer} est prête ! ",
          style: const TextStyle(fontSize: 25),
        )
      ],
    );
  }
}

class OrderReadyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('CurrentOrder').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var snap = snapshot.data!.docs;
            List<Order> orderList = [];
            for (int i = 0; i < snap.length; i++) {
              var customer = snap[i]['customer'];
              var drinkFinish = snap[i]['containDrink'];
              var foodFinish = snap[i]['containFood'];
              var finish = snap[i]['finish'];
              var isOnScreen = snap[i]['isOnScreen'];
              Timestamp dateTime = snap[i]['date'];
              DateTime date =
                  DateTime.fromMillisecondsSinceEpoch(dateTime.seconds * 1000);
              Order order = Order.television(
                  customer, drinkFinish, foodFinish, date, finish, isOnScreen);
              orderList.add(order);
            }
            orderList
                .sort((order1, order2) => order1.date.compareTo(order2.date));
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                child: Column(
                  children: [
                    const Text("Commande en cours de préparation...",
                        style: TextStyle(
                            fontSize: 45, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: OrderPreparingWidget(orderList),
                    ),
                    const Text("Commande finit",
                        style: TextStyle(
                            fontSize: 45, fontWeight: FontWeight.bold)),
                    Expanded(child: OrderFinishedWidget(orderList))
                  ],
                ),
              ),
            );
          }
        });
  }
}

class OrderPreparingWidget extends StatelessWidget {
  List<Order> orderList;
  OrderPreparingWidget(this.orderList, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: orderList.length,
        itemBuilder: (context, int index) {
          if (orderList[index].containFood) {
            return OrderPreparingItemWidget(orderList[index]);
          } else {
            return Container();
          }
        });
  }
}

class OrderPreparingItemWidget extends StatelessWidget {
  Order order;
  OrderPreparingItemWidget(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("${order.customer} en cours de préparation...",
            style: const TextStyle(fontSize: 25)),
      ],
    );
  }
}

class ItemListMenuWidget extends StatelessWidget {
  const ItemListMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Item').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          var snap = snapshot.data!.docs;
          List<Item> itemList = [];
          for (int i = 0; i < snap.length; i++) {
            String name = snap[i]['name'];
            var price = snap[i]['price'];
            bool isFood = snap[i]['isFood'];
            bool isAvailable = snap[i]['available'];
            Item item = Item(name, price.toDouble(), isFood, isAvailable);
            itemList.add(item);
          }

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Color.fromARGB(255, 0, 151, 144),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Boisson : ',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: itemList.length,
                  itemBuilder: (context, int index) {
                    if (!itemList[index].isFood &&
                        itemList[index].isAvailable) {
                      return itemMenuWidget(itemList[index]);
                    }
                    return Container();
                  }),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Color.fromARGB(255, 0, 151, 144),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Nourriture/Snack : ',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: itemList.length,
                  itemBuilder: (context, int index) {
                    if (itemList[index].isFood && itemList[index].isAvailable) {
                      return itemMenuWidget(itemList[index]);
                    }
                    return Container();
                  }),
            ],
          );
        }
      },
    );
  }
}

class itemMenuWidget extends StatelessWidget {
  final Item item;
  const itemMenuWidget(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      child: Row(
        children: [
          Text(item.name, style: const TextStyle(fontSize: 25)),
          const Spacer(),
          Text(
            "${item.price} €",
            style: const TextStyle(fontSize: 25),
          )
        ],
      ),
    );
  }
}
