import 'package:bar_commande/models/order.dart';
import 'package:bar_commande/pages/television_folder/order_finished_item_widget.dart';
import 'package:flutter/material.dart';

class OrderFinishedWidget extends StatefulWidget {
  final List<Order> orderList;
  const OrderFinishedWidget(this.orderList, {super.key});

  @override
  State<OrderFinishedWidget> createState() => _OrderFinishedWidgetState();
}

class _OrderFinishedWidgetState extends State<OrderFinishedWidget> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: widget.orderList.length,
          itemBuilder: (context, index) {
            if (widget.orderList[index].isOnScreen) {
              return OrderFinishedItemWidget(widget.orderList[index]);
            } else {
              return Container();
            }
          });
    });
  }
}