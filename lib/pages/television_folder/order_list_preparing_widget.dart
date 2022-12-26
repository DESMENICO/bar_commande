import 'package:flutter/material.dart';

import '../../models/order.dart';
import 'order_item_preparing_widget.dart';

class OrderPreparingWidget extends StatelessWidget {
  final List<Order> orderList;
  const OrderPreparingWidget(this.orderList, {super.key});

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