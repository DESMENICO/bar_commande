import 'package:flutter/material.dart';

class SellerListWidget extends StatelessWidget {
  final String _orderPerSeller;
  final String _seller;

  const SellerListWidget(this._orderPerSeller, this._seller, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Row(
          children: [
            Expanded(
                child: Row(children: [const Icon(Icons.person), Text(_seller)])),
            Expanded(
                child: Row(children: [
              const Icon(Icons.numbers),
              Text(_orderPerSeller)
            ])),
          ],
        ),
      ),
    );
  }
}