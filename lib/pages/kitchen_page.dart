import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import '../bloc/item_bloc.dart';
import '../bloc/order_bloc.dart';
import '../models/item.dart';
import '../models/order.dart';
import '../models/order_list.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_events.dart';
import '../bloc/order_states.dart';

class KitchenPage extends StatelessWidget {
  ItemBloc itemBloc;
  OrderBloc orderBloc;
  KitchenPage(this.itemBloc, this.orderBloc, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cuisine")),
      body: Column(children: [
        OrderListWidget(itemBloc, orderBloc),
      ]),
    );
  }
}

class OrderListWidget extends StatefulWidget {
  ItemBloc itemBloc;
  OrderBloc orderBloc;
  OrderListWidget(this.itemBloc, this.orderBloc, {super.key});
  @override
  State<OrderListWidget> createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.orderBloc.state.orders.length,
        itemBuilder: (context, int index) {
          return OrderWidget(widget.orderBloc.state.orders[index]);
        });
  }
}

class OrderWidget extends StatefulWidget {
  Order order;

  OrderWidget(this.order, {super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState(order);
}

class _OrderWidgetState extends State<OrderWidget> {
  Order order;
  _OrderWidgetState(this.order);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  order.customer,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Visibility(
                  visible: !order.drinkFinish,
                  child: const Icon(Icons.local_bar)),
              ),
             Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Visibility(
                  visible: !order.foodFinish,
                  child: const Icon(Icons.local_dining)),
              ),
              /*Text(
                order.customer,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              )*/
            ],
          ),
        ],
      ),
    );
  }
}
