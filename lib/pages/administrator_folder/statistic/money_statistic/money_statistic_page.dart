import 'package:bar_commande/models/order.dart';
import 'package:bar_commande/pages/administrator_folder/statistic/money_statistic/money_chart_widget.dart';
import 'package:bar_commande/pages/administrator_folder/statistic/money_statistic/order_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class MoneyStatistic extends StatefulWidget {
  final List<Order> orderList;
  const MoneyStatistic(this.orderList, {super.key});

  @override
  State<MoneyStatistic> createState() => _MoneyStatisticState();
}

class _MoneyStatisticState extends State<MoneyStatistic> {
  late String date;
  DateTime? selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  _selectDate(BuildContext context) async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2100));
        if(newDate!=null){
      selectedDate = newDate;
    }

    setState(() {
      if (selectedDate != null) {
        date = formatter.format(selectedDate!);
      }
    });

    
  }

  @override
  void initState() {
    super.initState();
    if (selectedDate != null) {
      date = formatter.format(selectedDate!);
    }
  }

  double getTotalOfTheDay(DateTime date) {
    double total = 0;
    for (Order order in widget.orderList) {
      if (order.date.month == selectedDate!.month &&
          order.date.day == selectedDate!.day &&
          order.date.year == selectedDate!.year) {
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
                  date,
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
                "Le montant de total de la journée ${NumberFormat("0.##").format(getTotalOfTheDay(selectedDate!))}€",
                style: const TextStyle(fontSize: 18),
                
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.orderList.length,
            itemBuilder: (context, index) {
              if (widget.orderList[index].date.month ==
                      selectedDate!.month &&
                  widget.orderList[index].date.day == selectedDate!.day &&
                  widget.orderList[index].date.year ==
                      selectedDate!.year) {
                return MoneyItemListWidget(widget.orderList[index]);
              } else {
                return Container();
              }
            },
          ),
        ),
        MoneyChart(selectedDate!, widget.orderList)
      ],
    ));
  }
}






