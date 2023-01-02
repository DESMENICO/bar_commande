import 'package:flutter/material.dart';
import '../../models/order.dart';

class OrderPreparingItemWidget extends StatelessWidget {
  final Order _order;
  const OrderPreparingItemWidget(this._order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("${_order.customer} en cours de préparation...",
            style: const TextStyle(fontSize: 25)),
      ],
    );
  }
}
