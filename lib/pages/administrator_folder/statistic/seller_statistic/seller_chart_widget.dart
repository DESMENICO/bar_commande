import 'package:bar_commande/models/seller_chart_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SellerChart extends StatefulWidget {
  final Map<String, int> _orderPerSeller;
  final List<String> _sellerList;
  const SellerChart(this._sellerList, this._orderPerSeller, {super.key});

  @override
  State<SellerChart> createState() => _SellerChartState();
}

List<SellerData> listChartData(Map<String, int> ordersPerSeller, List<String> sellersList) {
    List<SellerData> chartData =[];// <ChartData>[
      for(int i =0; i<ordersPerSeller.length; i++){
        chartData.add(SellerData(sellersList[i], ordersPerSeller[sellersList[i]]!));
      }
  return chartData;
}

class _SellerChartState extends State<SellerChart> {

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries<SellerData, String>>[
          // Renders column chart
          ColumnSeries<SellerData, String>(
              dataSource: listChartData(widget._orderPerSeller, widget._sellerList),
              xValueMapper: (SellerData data, _) => data.x,
              yValueMapper: (SellerData data, _) => data.y)
        ]);
  }
}