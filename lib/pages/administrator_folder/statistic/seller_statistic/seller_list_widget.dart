import 'package:flutter/material.dart';

class SellerListWidget extends StatelessWidget {
  final String ordersPerSeller;
  final String seller;

  const SellerListWidget(this.ordersPerSeller, this.seller, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Row(
          children: [
            Expanded(
                child: Row(children: [const Icon(Icons.person), Text(seller)])),
            Expanded(
                child: Row(children: [
              const Icon(Icons.numbers),
              Text(ordersPerSeller)
            ])),
          ],
        ),
      ),
    );
  }
}