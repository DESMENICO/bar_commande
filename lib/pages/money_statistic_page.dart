import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/order.dart';


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
                return MoneyStatisticWidget(widget.orderList[index]);
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

class MoneyChart extends StatefulWidget {
  final DateTime date;
  final List<Order> orderList;
  const MoneyChart(this.date,this.orderList,{super.key});

  @override
  State<MoneyChart> createState() => _MoneyChartState();
}

class _MoneyChartState extends State<MoneyChart> {
  final DateFormat formatter = DateFormat('dd/MM');
  List<DateTime> dateList = [];

  void generateList(DateTime date){
    dateList.add(date);
    for(int i = 0;i<6;i++) {
      dateList.add(date.subtract(Duration(days: i)));
      }
  }
  double getTotalOfTheDay(DateTime date) {
    double total = 0;
    for (Order order in widget.orderList) {
      if (order.date.month == date.month &&
          order.date.day == date.day &&
          order.date.year == date.year) {
        total += order.totalPrice;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    generateList(widget.date);
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      title: ChartTitle(text: "Revenue des sept derniers jours"),
      series: <LineSeries<MoneyData,String>>[
        LineSeries<MoneyData,String>(
          dataSource: <MoneyData>[
            MoneyData(formatter.format(widget.date.subtract(const Duration(days: 6))),getTotalOfTheDay(widget.date.subtract(const Duration(days: 6)))),  
            MoneyData(formatter.format(widget.date.subtract(const Duration(days: 5))),getTotalOfTheDay(widget.date.subtract(const Duration(days: 5)))), 
            MoneyData(formatter.format(widget.date.subtract(const Duration(days: 4))),getTotalOfTheDay(widget.date.subtract(const Duration(days: 4)))),
            MoneyData(formatter.format(widget.date.subtract(const Duration(days: 3))),getTotalOfTheDay(widget.date.subtract(const Duration(days: 3)))),
            MoneyData(formatter.format(widget.date.subtract(const Duration(days: 2))),getTotalOfTheDay(widget.date.subtract(const Duration(days: 2)))),
            MoneyData(formatter.format(widget.date.subtract(const Duration(days: 1))),getTotalOfTheDay(widget.date.subtract(const Duration(days: 1)))),
            MoneyData(formatter.format(widget.date),getTotalOfTheDay(widget.date)),
          ],
          xValueMapper: (MoneyData data, _) => data.date,
          yValueMapper: (MoneyData data, _) => data.total,
         )
      ]
    );
  }
}


class MoneyData{
  String date;
  double total;
  MoneyData(this.date,this.total);
}

class MoneyStatisticWidget extends StatelessWidget {
  final Order order;
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
