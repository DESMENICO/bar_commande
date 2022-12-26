import 'package:bar_commande/models/itemChartData.dart';
import 'package:bar_commande/models/order.dart';
import 'package:bar_commande/pages/administrator_folder/statistic/item_statistic/item_chart_widget.dart';
import 'package:bar_commande/pages/administrator_folder/statistic/item_statistic/item_global_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:intl/intl.dart';

class ItemStatistic extends StatefulWidget {
  final List<Order> orderlist;
  const ItemStatistic(this.orderlist, {super.key});

  @override
  State<ItemStatistic> createState() => _ItemStatisticState();
}

class _ItemStatisticState extends State<ItemStatistic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ItemChartWidget(widget.orderlist),
          Card(
            child: Center(
                child: ItemGlobalChart(widget.orderlist)),
          ),
        ],
      ),
    );
  }
}




