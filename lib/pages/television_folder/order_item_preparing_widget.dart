import 'package:flutter/material.dart';
import '../../models/order.dart';

class OrderPreparingItemWidget extends StatelessWidget {
  final Order order;
  const OrderPreparingItemWidget(this.order, {super.key});

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