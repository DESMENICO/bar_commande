import 'package:bar_commande/models/order.dart';
import 'package:bar_commande/pages/administrator_folder/statistic/money_statistic/money_chart_widget.dart';
import 'package:bar_commande/pages/administrator_folder/statistic/money_statistic/order_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoneyStatistic extends StatefulWidget {
  final List<Order> _orderList;
  const MoneyStatistic(this._orderList, {super.key});

  @override
  State<MoneyStatistic> createState() => _MoneyStatisticState();
}

class _MoneyStatisticState extends State<MoneyStatistic> {
  late String _date;
  DateTime? _selectedDate = DateTime.now();
  final DateFormat _formatter = DateFormat('dd/MM/yyyy');

  _selectDate(BuildContext context) async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2100));
    if (newDate != null) {
      _selectedDate = newDate;
    }

    setState(() {
      if (_selectedDate != null) {
        _date = _formatter.format(_selectedDate!);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (_selectedDate != null) {
      _date = _formatter.format(_selectedDate!);
    }
  }

  double getTotalOfTheDay(DateTime date) {
    double total = 0;
    for (Order order in widget._orderList) {
      if (order.date.month == _selectedDate!.month &&
          order.date.day == _selectedDate!.day &&
          order.date.year == _selectedDate!.year) {
        total += order.totalPrice;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  _date,
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Le montant de total de la journée ${NumberFormat("0.##").format(getTotalOfTheDay(_selectedDate!))}€",
                style: const TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget._orderList.length,
            itemBuilder: (context, index) {
              if (widget._orderList[index].date.month == _selectedDate!.month &&
                  widget._orderList[index].date.day == _selectedDate!.day &&
                  widget._orderList[index].date.year == _selectedDate!.year) {
                return MoneyItemListWidget(widget._orderList[index]);
              } else {
                return Container();
              }
            },
          ),
        ),
        MoneyChart(_selectedDate!, widget._orderList)
      ],
    );
  }
}
