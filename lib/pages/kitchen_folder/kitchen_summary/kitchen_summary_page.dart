import 'package:flutter/material.dart';
import '../../../models/order.dart';
import 'summary_item_widget.dart';
import 'summary_order_bottom_bar_widget.dart';

class KitchenSummaryPage extends StatelessWidget {
  final Order order;
  const KitchenSummaryPage(this.order, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Commande de ${order.customer}"),
      ),
      body: Column(children: [
        Expanded(child: SummaryItemWidget(order)),
        SummaryOrderBottomBarWidget(order)
      ]),
    );
  }
}






