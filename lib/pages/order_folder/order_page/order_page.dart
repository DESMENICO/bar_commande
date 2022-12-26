import 'package:bar_commande/bloc/order_events.dart';
import 'package:bar_commande/bloc/order_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/order_bloc.dart';
import '../../../models/order.dart' as models;

import '../../../models/user.dart';
import 'client_name_form_widget.dart';
import 'item_list_widget.dart';
import 'order_bottom_bar_widget.dart';

class OrderPage extends StatefulWidget {

  final User user;

  const OrderPage(this.user, {super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late models.Order order;
  @override
  void initState() {
    super.initState();
    order = models.Order("Nouveau Client");
    order.sellerId = widget.user.name;
    context.read<OrderBloc>().add(AddOrderEvent(order));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc,OrderState>(
      builder:((context, state) {
        order = state.orders.last;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Commande"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon:  const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.read<OrderBloc>().add(RemoveOrderEvent(order));
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(children: [
        ClientNameForms(order),
        Expanded(child: ItemListWidget(order)),
        OrderBottomBarWidget(order,widget.user)
      ]),
    );
      }) ,
    );
  }
}
