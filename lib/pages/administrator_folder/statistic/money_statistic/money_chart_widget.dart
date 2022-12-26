import 'package:bar_commande/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../models/moneyChartData.dart';


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