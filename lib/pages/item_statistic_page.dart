import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/item.dart';
import '../models/order.dart';

class ItemStatistic extends StatefulWidget {
  late List<Order> orderlist;
  List<ItemData> ItemDataList = [];
  ItemStatistic(this.orderlist, {super.key});

  @override
  State<ItemStatistic> createState() => _ItemStatisticState();
}

class _ItemStatisticState extends State<ItemStatistic> {
  late TooltipBehavior _tooltipBehavior;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container(child: SfCircularChart(
        title: ChartTitle(text: "Articles les plus vendus",
        textStyle: TextStyle(fontSize: 25)),
        tooltipBehavior: _tooltipBehavior,
        legend: Legend(isVisible: true,borderColor: Colors.black), 
        series: <CircularSeries>[
        PieSeries<ItemData,String>(
          dataSource: widget.ItemDataList,
          xValueMapper: (ItemData data, _) => data.name,
          yValueMapper: (ItemData data, _) => data.number,
          dataLabelSettings:DataLabelSettings(isVisible : true)
        )
      ]),)),
    );
  }


  @override
  void initState() {
    super.initState();
    _tooltipBehavior =  TooltipBehavior(enable: true);
    for(String itemName in getItemList()){
      double number = getNumber(itemName);
      widget.ItemDataList.add(ItemData(itemName, number));
    }
  }

  List<String> getItemList(){
    List<String> list = [];
    for(Order order in widget.orderlist){
        for(String itemUsed in order.itemUsed){
          list.add(itemUsed);
        }
    }
    
    return list.toSet().toList();;
  }

  double getNumber(String itemName){
    double number = 0;
     for(Order order in widget.orderlist){
      for(String item in order.itemUsed){
        if(item == itemName){
          number++;
        }
      }
    }
    return number;

  }
}

class ItemData{
  String name;
  double number;
  ItemData(this.name,this.number);
}
