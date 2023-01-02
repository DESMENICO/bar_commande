import 'package:bar_commande/pages/television_folder/item_list_menu_widget.dart';
import 'package:bar_commande/pages/television_folder/order_ready_widget.dart';
import 'package:flutter/material.dart';

class TelevisionPage extends StatelessWidget {
  const TelevisionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(children: const <Widget>[
      Expanded(child: Card(child: ItemListMenuWidget())),
      Expanded(child: OrderReadyWidget()),
    ]));
  }
}
