import 'package:bar_commande/models/order.dart';
import 'package:bar_commande/services/firestore_service.dart';
import 'package:flutter/material.dart';

class SummaryOrderBottombar extends StatefulWidget {
  final Order order;

  const SummaryOrderBottombar(this.order, {super.key});

  @override
  State<SummaryOrderBottombar> createState() => _SummaryOrderBottombarState();
}

class _SummaryOrderBottombarState extends State<SummaryOrderBottombar> {
  bool isPaid = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Visibility(
          visible: !isPaid,
          child: ElevatedButton(
            onPressed: () {
              setState(() { 
                  isPaid =true;
              });
                     },
            child: Text(
              "Payer : ${widget.order.totalPrice}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Visibility(
          visible: isPaid,
          child: ElevatedButton(
            onPressed: () async {
              DataBase database = DataBase();
              widget.order.checkFoodAndDrink();
              await database.addCurrentOrder(widget.order);
              await database.addOrder(widget.order);
              Navigator.pop(context,Order("Nouveau Client"));
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