import 'package:flutter/material.dart';
import '../models/item.dart';
import '../models/order.dart';
import '../models/order_list.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_events.dart';
import '../bloc/order_states.dart';


class KitchenPage extends StatelessWidget {
  const KitchenPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cuisine")),
      body: Column(children: [
        const OrderListWidget()
      ]),
    );
  }
}

class OrderListWidget extends StatefulWidget {
  const OrderListWidget({super.key});
  @override
  State<OrderListWidget> createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
  late OrderBloc _bloc;
  @override
    void initState() {
      super.initState();
      List<Order> orders = List.generate(
          10,
          (index) => Order('Client $index'));
      _bloc = OrderBloc(orders);

  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: commandes.commandesList.length,
        itemBuilder: (context, int index) {
          return OrderWidget(commandes.commandesList[index]);
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
              const Icon(Icons.check),
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
