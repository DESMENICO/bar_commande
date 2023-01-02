import 'package:flutter/material.dart';

import '../../../../models/order.dart';
import 'seller_chart_widget.dart';
import 'seller_list_widget.dart';

class SellerStatisticPage extends StatefulWidget {
  final List<Order> orderList;

  const SellerStatisticPage(this.orderList, {super.key});

  @override
  State<SellerStatisticPage> createState() => _SellerStatisticPageState();
}

class _SellerStatisticPageState extends State<SellerStatisticPage> {
   Map<String, int> ordersPerSeller = {};
   List<String> sellersList = [];
  @override
  void initState() {
    super.initState();
    setOrderPerSeller();
  }

  void setOrderPerSeller() {
    for (Order order in widget.orderList) {
      if (ordersPerSeller.containsKey(order.sellerId)) {
         ordersPerSeller[order.sellerId] =
            ordersPerSeller[order.sellerId]! + 1;
      } else {
        ordersPerSeller[order.sellerId] = 1;
      }
    }
    sellersList = ordersPerSeller.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sellersList.length,
            itemBuilder: (context, index) {
              return SellerListWidget(
                  ordersPerSeller[sellersList[index]].toString(),
                  sellersList[index]);
            },
          ),
        ),
        SellerChart(sellersList, ordersPerSeller)
      ],
    );
  }
}








