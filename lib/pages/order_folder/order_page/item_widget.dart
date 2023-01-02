import 'package:bar_commande/bloc/order_bloc.dart';
import 'package:bar_commande/bloc/order_events.dart';
import 'package:bar_commande/bloc/order_states.dart';
import 'package:bar_commande/models/item.dart';
import 'package:flutter/material.dart';
import 'package:bar_commande/models/order.dart' as models;
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemWidget extends StatefulWidget {
  final Item _item;
  final models.Order _order;

  const ItemWidget(this._item, this._order, {super.key});

  @override
  State<ItemWidget> createState() => _ItemWidgetState(); //item);
}

class _ItemWidgetState extends State<ItemWidget> {
  _ItemWidgetState();

  void _incrementItemNumber() {
    widget._order.addItem(widget._item);
    context.read<OrderBloc>().add(UpdateOrderEvent(widget._order));
  }

  void _decrementItemNumber() {
    widget._order.removeItem(widget._item);
    setState(() {
      context.read<OrderBloc>().add(UpdateOrderEvent(widget._order));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget._item.isAvailable,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Card(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget._item.name,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    "${widget._item.price}€",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _decrementItemNumber,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                  ),
                  child: const Text(
                    "-",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: BlocBuilder<OrderBloc, OrderState>(
                    builder: (context, state) => Text(
                      state.orders.last.getItemNumber(widget._item).toString(),
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _incrementItemNumber,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                  ),
                  child: const Text(
                    "+",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
