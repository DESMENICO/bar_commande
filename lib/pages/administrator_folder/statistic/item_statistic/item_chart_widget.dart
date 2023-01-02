import 'package:bar_commande/models/order.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../../../../models/item_chart_data.dart';


class ItemChartWidget extends StatefulWidget {
  final List<Order> orderList;
  const ItemChartWidget(this.orderList, {super.key});
  @override
  State<ItemChartWidget> createState() =>
      _ItemChartWidgetState();
}

class _ItemChartWidgetState extends State<ItemChartWidget> {
  DateTime? selectedDate = DateTime.now();
  late String date;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  late TooltipBehavior _tooltipBehavior;

  _selectDate(BuildContext context) async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2100));
    if (newDate != null) {
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
    selectedDate = DateTime.now();
    date = formatter.format(selectedDate!);
    _tooltipBehavior = TooltipBehavior(enable: true);
    if (selectedDate != null) {
      date = formatter.format(selectedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
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
                  Text(date),
                ],
              ),
            ),
          ),
          SizedBox(
            child: SfCircularChart(
                title: ChartTitle(
                    text: "Articles vendus le $date",
                    textStyle: const TextStyle(fontSize: 25)),
                tooltipBehavior: _tooltipBehavior,
                legend: Legend(
                  isVisible: true,
                  borderColor: Colors.black,
                ),
                series: <CircularSeries>[
              PieSeries<ItemData, String>(
                  dataSource: getItemDataList(date),
                  xValueMapper: (ItemData data, _) => data.name,
                  yValueMapper: (ItemData data, _) => data.number,
                  dataLabelSettings: const DataLabelSettings(isVisible: true))
            ]),
          )
        ],
      ),
    );
  }

  List<ItemData> getItemDataList(String date) {
    List<String> itemNameList = [];
    List<ItemData> itemDataList = [];
    List<Order> orderOfTheDayList = [];

    for (Order order in widget.orderList) {
      if (order.date.month == selectedDate!.month &&
          order.date.day == selectedDate!.day &&
          order.date.year == selectedDate!.year) {
        orderOfTheDayList.add(order);
        for (String string in order.itemUsed) {
          itemNameList.add(string);
        }
      }
    }
    itemNameList = itemNameList.toSet().toList();

    for (String itemName in itemNameList) {
      itemDataList
          .add(ItemData(itemName, getNumber(itemName, orderOfTheDayList)));
    }
    return itemDataList;
  }

  double getNumber(String itemName, List<Order> orderList) {
    double number = 0;
    for (Order order in orderList) {
      for (String item in order.itemUsed) {
        if (item == itemName) {
          number++;
        }
      }
    }
    return number;
  }
}
