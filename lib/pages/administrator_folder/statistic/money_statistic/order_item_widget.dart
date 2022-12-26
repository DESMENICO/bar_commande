import 'package:bar_commande/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MoneyItemListWidget extends StatelessWidget {
  final Order order;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  MoneyItemListWidget(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Row(children: [
          Expanded(
              child: Row(
                  children: [const Icon(Icons.people), Text(order.customer)])),
          Expanded(
              child: Row(children: [
            const Icon(Icons.euro_symbol),
            Text(NumberFormat("0.##").format(order.totalPrice))
          ])),
        ]),
        Row(children: [
          Expanded(
              child: Row(children: [
            const Icon(Icons.calendar_view_day),
            Text(formatter.format(order.date))
          ])),
          Expanded(
              child: Row(
                  children: [const Icon(Icons.sell), Text(order.sellerId)])),
        ])
      ]),
    );
  }
}