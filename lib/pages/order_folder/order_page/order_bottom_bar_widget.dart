import 'package:bar_commande/bloc/order_bloc.dart';
import 'package:bar_commande/bloc/order_events.dart';
import 'package:bar_commande/bloc/order_states.dart';
import 'package:bar_commande/models/user.dart';
import 'package:flutter/material.dart';
import 'package:bar_commande/models/order.dart' as models;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../order_summary/order_summary.dart';

class OrderBottomBarWidget extends StatefulWidget {
  models.Order order;
  final User user;
  OrderBottomBarWidget(this.order,this.user, {super.key});
  @override
  State<OrderBottomBarWidget> createState() => _OrderBottomBar();
}

class _OrderBottomBar extends State<OrderBottomBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrderSummary(widget.order),
                ),
              );
              widget.order = models.Order("Nouveau Client");
              widget.order.sellerId = widget.user.name;
              context.read<OrderBloc>().add(AddOrderEvent(widget.order));
            },
            child: const Text(
              "Total",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) => Text(
              "${state.orders.last.totalPrice}€",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }
}
