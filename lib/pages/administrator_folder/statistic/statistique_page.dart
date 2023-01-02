
import 'package:bar_commande/pages/administrator_folder/statistic/item_statistic/item_statistic_page.dart';
import 'package:bar_commande/pages/administrator_folder/statistic/money_statistic/money_statistic_page.dart';
import 'package:bar_commande/pages/administrator_folder/statistic/seller_statistic/seller_statistic_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/order.dart';

class StatisticPage extends StatelessWidget {
  StatisticPage({super.key});
  
  final List<Order> _orderList = [];

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
                  double totalPrice = snap[i]['totalPrice'].toDouble();
                  List<dynamic> itemUsed = snap[i]['items']; 
                  Timestamp dateTime = snap[i]['date'];
                  DateTime date = DateTime.fromMillisecondsSinceEpoch(dateTime.seconds*1000);
                  _orderList.add(Order.statistic(customer,totalPrice,seller,date,itemUsed.cast<String>()));
            }
            _orderList.sort((order1,order2) => order1.date.compareTo(order2.date));


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
                  MoneyStatistic(_orderList),
                  SellerStatisticPage(_orderList),
                  ItemStatistic(_orderList),
                ],)
                ));
      }
  });
  }
}