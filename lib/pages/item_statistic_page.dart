import 'package:bar_commande/pages/order_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:intl/intl.dart';
import '../models/item.dart';
import '../models/order.dart';

class ItemStatistic extends StatefulWidget {
  late List<Order> orderlist;
  ItemStatistic(this.orderlist, {super.key});

  @override
  State<ItemStatistic> createState() => _ItemStatisticState();
}

class _ItemStatisticState extends State<ItemStatistic> {
  late TooltipBehavior _tooltipBehavior;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SpecificDayItemStatistic(widget.orderlist),
          Card(
            child: Center(child: Container(child: SfCircularChart(
              title: ChartTitle(text: "Ventes globales des articles",
              textStyle: const TextStyle(fontSize: 25)),
              tooltipBehavior: _tooltipBehavior,
              legend: Legend(isVisible: true,borderColor: Colors.black,), 
              series: <CircularSeries>[
              PieSeries<ItemData,String>(
                dataSource: getItemDataList(),
                xValueMapper: (ItemData data, _) => data.name,
                yValueMapper: (ItemData data, _) => data.number,
                dataLabelSettings:const DataLabelSettings(isVisible : true)
              )
            ]),)),
          ),
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _tooltipBehavior =  TooltipBehavior(enable: true);
  }

  List<ItemData> getItemDataList() {
    List<ItemData> itemDataList = [];
    for(String itemName in getItemList()){
      double number = getNumber(itemName);
      itemDataList.add(ItemData(itemName, number));
    }
    return itemDataList;
  }

  List<String> getItemList(){
    List<String> list = [];
    for(Order order in widget.orderlist){
        for(String itemUsed in order.itemUsed){
          list.add(itemUsed);
        }
    }
    
    return list.toSet().toList();
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

class SpecificDayItemStatistic extends StatefulWidget {
  List<Order> orderList;
  SpecificDayItemStatistic(this.orderList,{super.key});
  DateTime? selectedDate = DateTime.now();
  @override
  State<SpecificDayItemStatistic> createState() => _SpecificDayItemStatisticState();
}

class _SpecificDayItemStatisticState extends State<SpecificDayItemStatistic> {
  late String date;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  late TooltipBehavior _tooltipBehavior;

  _selectDate(BuildContext context) async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2100));
    if(newDate!=null){
      widget.selectedDate = newDate;
    }
    setState(() {
      if (widget.selectedDate != null) {
        date = formatter.format(widget.selectedDate!);
      }
    });}

    @override
      void initState() {
    super.initState();
    widget.selectedDate = DateTime.now();
    date = formatter.format(widget.selectedDate!);
    _tooltipBehavior =  TooltipBehavior(enable: true);
    if (widget.selectedDate != null) {
      date = formatter.format(widget.selectedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
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
          Center(child: Container(child: SfCircularChart(
              title: ChartTitle(text: "Articles vendus le ${date}",
              textStyle: const TextStyle(fontSize: 25)),
              tooltipBehavior: _tooltipBehavior,
              legend: Legend(isVisible: true,borderColor: Colors.black,), 
              series: <CircularSeries>[
              PieSeries<ItemData,String>(
                dataSource: getItemDataList(date),
                xValueMapper: (ItemData data, _) => data.name,
                yValueMapper: (ItemData data, _) => data.number,
                dataLabelSettings:const DataLabelSettings(isVisible : true)
              )
            ]),))],),
    );
  }

  List<ItemData> getItemDataList(String date){
    List<String> itemNameList =[];
    List<ItemData> itemDataList = [];
    List<Order> orderOfTheDayList = [];

    for(Order order in widget.orderList){
       if (order.date.month == widget.selectedDate!.month &&
          order.date.day == widget.selectedDate!.day &&
          order.date.year == widget.selectedDate!.year) {
            orderOfTheDayList.add(order);
            for(String string in order.itemUsed){
              itemNameList.add(string);
            }
      }
    }
    itemNameList = itemNameList.toSet().toList();

    for(String itemName in itemNameList){
      itemDataList.add(ItemData(itemName, getNumber(itemName, orderOfTheDayList)));
    }
    return itemDataList;
  }

  double getNumber(String itemName,List<Order> orderList){
    double number = 0;
     for(Order order in orderList){
      for(String item in order.itemUsed){
        if(item == itemName){
          number++;
        }
      }
    }
    return number;

  }

}

