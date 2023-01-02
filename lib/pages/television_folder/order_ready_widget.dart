


import 'package:bar_commande/pages/television_folder/television_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/order.dart';
import 'order_finished_list_widget.dart';
import 'order_list_preparing_widget.dart';

class OrderReadyWidget extends StatelessWidget {
  const OrderReadyWidget({super.key});

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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: const Color.fromARGB(255, 0, 151, 144),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Commande en cours de Préparation ',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: OrderPreparingWidget(orderList),
                    ),Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: const Color.fromARGB(255, 0, 151, 144),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Commande terminée ',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  
                    Expanded(child: OrderFinishedWidget(orderList))
                  ],
                ),
              ),
            );
          }
        });
  }
}