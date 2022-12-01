import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/item.dart';
import '../models/order.dart';

class ItemStatistic extends StatefulWidget {
  late List<Order> orderlist;
  List<String> itemNameList = [];
  List<ItemData> ItemDataList = [];
  ItemStatistic(this.orderlist, {super.key});

  @override
  State<ItemStatistic> createState() => _ItemStatisticState();
}

class _ItemStatisticState extends State<ItemStatistic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container()),
    );
  }


  @override
  void initState() {
    super.initState();
    print("hello world");
    for(String itemName in getItemList()){
      double number = getNumber(itemName);
      widget.ItemDataList.add(ItemData(itemName, number));
      
      print("nom: ${itemName} nombre: ${number}");
    }


  }

  List<String> getItemList(){
    List<String> list = [];
    for(Order order in widget.orderlist){
      for(Item item in order.itemList){
        print(item.name);
        if(list.contains(item.name)){
          
        }
      }
    }
    return list;
  }

  double getNumber(String itemName){
    double number = 0;
     for(Order order in widget.orderlist){
      for(Item item in order.itemList){
        if(order.itemList.contains(itemName)){
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
