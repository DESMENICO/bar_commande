import 'package:bar_commande/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MoneyItemListWidget extends StatelessWidget {
  final Order _order;
  final DateFormat _formatter = DateFormat('dd/MM/yyyy');
  MoneyItemListWidget(this._order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Row(children: [
          Expanded(
              child: Row(
                  children: [const Icon(Icons.people), Text(_order.customer)])),
          Expanded(
              child: Row(children: [
            const Icon(Icons.euro_symbol),
            Text(NumberFormat("0.##").format(_order.totalPrice))
          ])),
        ]),
        Row(children: [
          Expanded(
              child: Row(children: [
            const Icon(Icons.calendar_view_day),
            Text(_formatter.format(_order.date))
          ])),
          Expanded(
              child: Row(
                  children: [const Icon(Icons.sell), Text(_order.sellerId)])),
        ])
      ]),
    );
  }
}