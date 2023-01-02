import 'package:flutter/material.dart';

import '../../../models/order.dart';
import 'summary_item_widget.dart';
import 'summary_order_bottom_bar_widget.dart';

class OrderSummary extends StatelessWidget {
  final Order _order;
  const OrderSummary(this._order, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Commande de ${_order.customer}"),
      ),
      body: Column(children: [
        Expanded(child: SummaryItem(_order)),
        SummaryOrderBottombar(_order)
      ]),
    );
  }
}




