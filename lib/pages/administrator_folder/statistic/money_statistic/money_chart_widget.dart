import 'package:bar_commande/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../models/money_chart_data.dart';

class MoneyChart extends StatefulWidget {
  final DateTime _date;
  final List<Order> _orderList;
  const MoneyChart(this._date, this._orderList, {super.key});

  @override
  State<MoneyChart> createState() => _MoneyChartState();
}

class _MoneyChartState extends State<MoneyChart> {
  final DateFormat formatter = DateFormat('dd/MM');
  List<DateTime> dateList = [];

  void generateList(DateTime date) {
    dateList.add(date);
    for (int i = 0; i < 6; i++) {
      dateList.add(date.subtract(Duration(days: i)));
    }
  }

  double getTotalOfTheDay(DateTime date) {
    double total = 0;
    for (Order order in widget._orderList) {
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
    generateList(widget._date);
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(text: "Revenue des sept derniers jours"),
        series: <LineSeries<MoneyData, String>>[
          LineSeries<MoneyData, String>(
            dataSource: <MoneyData>[
              MoneyData(
                  formatter
                      .format(widget._date.subtract(const Duration(days: 6))),
                  getTotalOfTheDay(
                      widget._date.subtract(const Duration(days: 6)))),
              MoneyData(
                  formatter
                      .format(widget._date.subtract(const Duration(days: 5))),
                  getTotalOfTheDay(
                      widget._date.subtract(const Duration(days: 5)))),
              MoneyData(
                  formatter
                      .format(widget._date.subtract(const Duration(days: 4))),
                  getTotalOfTheDay(
                      widget._date.subtract(const Duration(days: 4)))),
              MoneyData(
                  formatter
                      .format(widget._date.subtract(const Duration(days: 3))),
                  getTotalOfTheDay(
                      widget._date.subtract(const Duration(days: 3)))),
              MoneyData(
                  formatter
                      .format(widget._date.subtract(const Duration(days: 2))),
                  getTotalOfTheDay(
                      widget._date.subtract(const Duration(days: 2)))),
              MoneyData(
                  formatter
                      .format(widget._date.subtract(const Duration(days: 1))),
                  getTotalOfTheDay(
                      widget._date.subtract(const Duration(days: 1)))),
              MoneyData(formatter.format(widget._date),
                  getTotalOfTheDay(widget._date)),
            ],
            xValueMapper: (MoneyData data, _) => data.date,
            yValueMapper: (MoneyData data, _) => data.total,
          )
        ]);
  }
}
