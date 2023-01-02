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

  final User _user;

  const OrderPage(this._user, {super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late models.Order _order;
  @override
  void initState() {
    super.initState();
    _order = models.Order("Nouveau Client");
    _order.sellerId = widget._user.name;
    context.read<OrderBloc>().add(AddOrderEvent(_order));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc,OrderState>(
      builder:((context, state) {
        _order = state.orders.last;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Commande"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon:  const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.read<OrderBloc>().add(RemoveOrderEvent(_order));
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(children: [
        ClientNameForms(_order),
        Expanded(child: ItemListWidget(_order)),
        OrderBottomBarWidget(_order,widget._user)
      ]),
    );
      }) ,
    );
  }
}
