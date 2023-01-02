import 'package:bar_commande/models/order.dart';
import 'package:bar_commande/pages/kitchen_folder/kitchen_summary/kitchen_summary_page.dart';
import 'package:flutter/material.dart';

class OrderWidget extends StatefulWidget {
  final Order _order;
  const OrderWidget(this._order, {super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  _OrderWidgetState();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget._order.containDrink || widget._order.containFood,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          child: InkWell(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => KitchenSummaryPage(widget._order),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        widget._order.customer,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Visibility(
                          visible: widget._order.containDrink,
                          child: const Icon(Icons.local_bar)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Visibility(
                          visible: widget._order.containFood,
                          child: const Icon(Icons.local_dining)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
