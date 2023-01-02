import 'package:flutter/material.dart';

import '../../models/order.dart';
import 'order_item_preparing_widget.dart';

class OrderPreparingWidget extends StatelessWidget {
  final List<Order> _orderList;
  const OrderPreparingWidget(this._orderList, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _orderList.length,
        itemBuilder: (context, int index) {
          if (_orderList[index].containFood) {
            return OrderPreparingItemWidget(_orderList[index]);
          } else {
            return Container();
          }
        });
  }
}