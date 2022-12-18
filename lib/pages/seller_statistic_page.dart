import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/order.dart';

class SellerStatisticPage extends StatefulWidget {
  final List<Order> orderList;

  const SellerStatisticPage(this.orderList, {super.key});

  @override
  State<SellerStatisticPage> createState() => _SellerStatisticPageState();
}

class _SellerStatisticPageState extends State<SellerStatisticPage> {
   Map<String, int> ordersPerSeller = {};
   List<String> sellersList = [];
  @override
  void initState() {
    super.initState();
    setOrderPerSeller();
  }

  void setOrderPerSeller() {
    for (Order order in widget.orderList) {
      if (ordersPerSeller.containsKey(order.sellerId)) {
         ordersPerSeller[order.sellerId] =
            ordersPerSeller[order.sellerId]! + 1;
      } else {
        ordersPerSeller[order.sellerId] = 1;
      }
    }
    sellersList = ordersPerSeller.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sellersList.length,
            itemBuilder: (context, index) {
              return SellerStatisticWidget(
                  ordersPerSeller[sellersList[index]].toString(),
                  sellersList[index]);
            },
          ),
        ),
        SellerChart(sellersList, ordersPerSeller)
      ],
    ));
  }
}

class SellerStatisticWidget extends StatelessWidget {
  final String ordersPerSeller;
  final String seller;

  const SellerStatisticWidget(this.ordersPerSeller, this.seller, {super.key});

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
  final Map<String, int> ordersPerSeller;
  final List<String> sellersList;
  const SellerChart(this.sellersList, this.ordersPerSeller, {super.key});

  @override
  State<SellerChart> createState() => _SellerChartState();
}

List<ChartData> listChartData(Map<String, int> ordersPerSeller, List<String> sellersList) {
    List<ChartData> chartData =[];// <ChartData>[
      for(int i =0; i<ordersPerSeller.length; i++){
        chartData.add(ChartData(sellersList[i], ordersPerSeller[sellersList[i]]!));
      }
  return chartData;
}

class _SellerChartState extends State<SellerChart> {

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries<ChartData, String>>[
          // Renders column chart
          ColumnSeries<ChartData, String>(
              dataSource: listChartData(widget.ordersPerSeller, widget.sellersList),
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y)
        ]);
  }
}



class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int y;
}
