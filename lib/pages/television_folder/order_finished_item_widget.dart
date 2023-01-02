

import 'package:bar_commande/models/order.dart';
import 'package:flutter/material.dart';

class OrderFinishedItemWidget extends StatefulWidget {
  final Order _order;
  const OrderFinishedItemWidget(this._order, {super.key});

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
          "La commande de ${widget._order.customer} est prête ! ",
          style: const TextStyle(fontSize: 25),
        )
      ],
    );
  }
}