import 'package:bar_commande/models/order.dart';
import 'package:bar_commande/pages/kitchen_summary_page.dart';
import 'package:flutter/material.dart';


class OrderWidget extends StatefulWidget {
  final Order order;
  const OrderWidget(this.order, {super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();//order);
}

class _OrderWidgetState extends State<OrderWidget> {
  //Order order;
  _OrderWidgetState();//this.order);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.order.containDrink || widget.order.containFood,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          child: InkWell(
            onTap: () async {
               await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => KitchenSummary(widget.order),
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
                        widget.order.customer,
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
                          visible: widget.order.containDrink,
                          child: const Icon(Icons.local_bar)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Visibility(
                          visible: widget.order.containFood,
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
