import 'package:bar_commande/pages/money_statistic_page.dart';
import 'package:bar_commande/pages/seller_statistic_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/order.dart';

class StatisticPage extends StatelessWidget {
  StatisticPage({super.key});
  List<Order> orderList = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Order").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
            return const Center(
              child:  CircularProgressIndicator(),
            );
          } else {
            var snap = snapshot.data!.docs;
            for(int i = 0; i < snap.length;i++){
                  var customer = snap[i]['customer'];
                  var seller = snap[i]['sellerId'];
                  double totalPrice = snap[i]['totalPrice'];
                  Timestamp dateTime = snap[i]['date'];
                  DateTime date = DateTime.fromMillisecondsSinceEpoch(dateTime.seconds*1000);
                  orderList.add(Order.statistic(customer,totalPrice,seller,date));
            }
            orderList.sort((order1,order2) => order1.date.compareTo(order2.date));


            return DefaultTabController(
                length:3,
                child: Scaffold(
                  appBar: AppBar(title: const Text("Statistiques"),
                    bottom: const TabBar(tabs: [
                    Tab(icon: Icon(Icons.euro),),
                    Tab(icon: Icon(Icons.people),),
                    Tab(icon: Icon(Icons.wallet),),
                  ]),
                ),
                body: TabBarView(children: [
                  MoneyStatistic(orderList),
                  SellerStatisticPage(orderList),
                  MoneyStatistic([]),
                ],)
                ));
      }
  });
  }
}