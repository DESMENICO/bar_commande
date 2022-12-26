import 'package:bar_commande/models/item_chart_data.dart';
import 'package:bar_commande/models/order.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class ItemGlobalChart extends StatefulWidget{
  final List<Order> orderlist;
  const ItemGlobalChart(this.orderlist, {super.key});
  @override
  State<ItemGlobalChart> createState() => _ItemGlobalChart();
  
}

class _ItemGlobalChart extends State<ItemGlobalChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
                    title: ChartTitle(
                        text: "Ventes globales des articles",
                        textStyle: const TextStyle(fontSize: 25)),
                    tooltipBehavior: _tooltipBehavior,
                    legend: Legend(
                      isVisible: true,
                      borderColor: Colors.black,
                    ),
                    series: <CircularSeries>[
                  PieSeries<ItemData, String>(
                      dataSource: getItemDataList(),
                      xValueMapper: (ItemData data, _) => data.name,
                      yValueMapper: (ItemData data, _) => data.number,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true))
                ]);
  }


  List<ItemData> getItemDataList() {
    List<ItemData> itemDataList = [];
    for (String itemName in getItemList()) {
      double number = getNumber(itemName);
      itemDataList.add(ItemData(itemName, number));
    }
    return itemDataList;
  }

  List<String> getItemList() {
    List<String> list = [];
    for (Order order in widget.orderlist) {
      for (String itemUsed in order.itemUsed) {
        list.add(itemUsed);
      }
    }

    return list.toSet().toList();
  }

  

  double getNumber(String itemName) {
    double number = 0;
    for (Order order in widget.orderlist) {
      for (String item in order.itemUsed) {
        if (item == itemName) {
          number++;
        }
      }
    }
    return number;
  }

}

