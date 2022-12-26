import 'package:flutter/material.dart';
import 'order_list_widget.dart';

class KitchenPage extends StatelessWidget {
  const KitchenPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cuisine")),
      body: Column(children: const [
        OrderListWidget(),
      ]),
    );
  }
}



