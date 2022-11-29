import 'dart:html';

import 'package:bar_commande/models/order_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';

class MoneyStatistic extends StatefulWidget {
  late List<Order> orderList;
  MoneyStatistic(this.orderList, {super.key});
  DateTime? selectedDate = DateTime.now();
  late String date;

  @override
  State<MoneyStatistic> createState() => _MoneyStatisticState();
}

class _MoneyStatisticState extends State<MoneyStatistic> {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  _selectDate(BuildContext context) async {
    widget.selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2100));

    setState(() {
      if (widget.selectedDate != null)
        widget.date = formatter.format(widget.selectedDate!);
    });
  }

  @override
  void initState() {
    if (widget.selectedDate != null) {
      widget.date = formatter.format(widget.selectedDate!);
    }
  }

  double getTotalOfTheDay(DateTime date) {
    double total = 0;
    for (Order order in widget.orderList) {
      if (order.date.month == widget.selectedDate!.month &&
          order.date.day == widget.selectedDate!.day &&
          order.date.year == widget.selectedDate!.year) {
        total += order.totalPrice;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: () async {
              _selectDate(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_month),
                Text(
                  widget.date,
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Text(
              "Le montant de total de la journée ${getTotalOfTheDay(widget.selectedDate!).toString()}",
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.orderList.length,
          itemBuilder: (context, index) {
            if (widget.orderList[index].date.month ==
                    widget.selectedDate!.month &&
                widget.orderList[index].date.day == widget.selectedDate!.day &&
                widget.orderList[index].date.year ==
                    widget.selectedDate!.year) {
              return MoneyStatisticWidget(widget.orderList[index]);
            } else {
              return Container();
            }
          },
        ),
      ],
    ));
  }
}

class MoneyStatisticWidget extends StatelessWidget {
  Order order;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  MoneyStatisticWidget(this.order, {super.key});

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
            Text(order.totalPrice.toString())
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
