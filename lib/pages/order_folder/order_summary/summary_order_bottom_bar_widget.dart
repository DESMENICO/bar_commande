import 'package:bar_commande/models/order.dart';
import 'package:bar_commande/services/firestore_service.dart';
import 'package:flutter/material.dart';

class SummaryOrderBottombar extends StatefulWidget {
  final Order _order;

  const SummaryOrderBottombar(this._order, {super.key});

  @override
  State<SummaryOrderBottombar> createState() => _SummaryOrderBottombarState();
}

class _SummaryOrderBottombarState extends State<SummaryOrderBottombar> {
  bool _isPaid = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Visibility(
          visible: !_isPaid,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _isPaid = true;
              });
            },
            child: Text(
              "Payer : ${widget._order.totalPrice}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Visibility(
          visible: _isPaid,
          child: ElevatedButton(
            onPressed: () async {
              DataBase database = DataBase();
              widget._order.checkFoodAndDrink();
              await database.addCurrentOrder(widget._order);
              await database.addOrder(widget._order);
              if (!mounted) return;
              Navigator.pop(context, Order("Nouveau Client"));
            },
            child: const Text(
              "Envoyer en cuisine",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        )
      ]),
    );
  }
}
