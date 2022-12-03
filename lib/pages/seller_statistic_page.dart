import 'package:bar_commande/models/order_list.dart';
import 'package:bar_commande/pages/money_statistic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/order.dart';

class SellerStatisticPage extends StatefulWidget {
  List<Order> orderList;
  late Map<String, int> ordersPerSeller;
  late List<String> sellersList;
  SellerStatisticPage(this.orderList, {super.key});

  @override
  State<SellerStatisticPage> createState() => _SellerStatisticPageState();
}

class _SellerStatisticPageState extends State<SellerStatisticPage> {
  @override
  void initState() {
    super.initState();
    setOrderPerSeller();
  }

  void setOrderPerSeller() {
    widget.ordersPerSeller = {};
    for (Order order in widget.orderList) {
      if (widget.ordersPerSeller.containsKey(order.sellerId)) {
        widget.ordersPerSeller[order.sellerId] =
            widget.ordersPerSeller[order.sellerId]! + 1;
      } else {
        widget.ordersPerSeller[order.sellerId] = 1;
      }
    }
    widget.sellersList = widget.ordersPerSeller.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.sellersList.length,
            itemBuilder: (context, index) {
              return SellerStatisticWidget(
                  widget.ordersPerSeller[widget.sellersList[index]].toString(),
                  widget.sellersList[index]);
            },
          ),
        ),
        SellerChart(widget.sellersList, widget.ordersPerSeller)
      ],
    ));
  }
}

class SellerStatisticWidget extends StatelessWidget {
  String ordersPerSeller;
  String seller;

  SellerStatisticWidget(this.ordersPerSeller, this.seller, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Row(
          children: [
            Expanded(
                child: Row(children: [const Icon(Icons.person), Text(seller)])),
            Expanded(
                child: Row(children: [
              const Icon(Icons.numbers),
              Text(ordersPerSeller)
            ])),
          ],
        ),
      ),
    );
  }
}

class SellerChart extends StatefulWidget {
  Map<String, int> ordersPerSeller;
  List<String> sellersList;
  SellerChart(this.sellersList, this.ordersPerSeller, {super.key});

  @override
  State<SellerChart> createState() => _SellerChartState();
}

class _SellerChartState extends State<SellerChart> {

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries<ChartData, String>>[
          // Renders column chart
          ColumnSeries<ChartData, String>(
              dataSource: ListChartData(widget.ordersPerSeller, widget.sellersList),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y)
        ]);
  }
}

List<ChartData> ListChartData(
    Map<String, int> ordersPerSeller, List<String> sellersList) {
    List<ChartData> chartData =[];// <ChartData>[
      for(int i =0; i<ordersPerSeller.length; i++){
        chartData.add(ChartData(sellersList[i], ordersPerSeller[sellersList[i]]!));
      }
  return chartData;
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int y;
}
