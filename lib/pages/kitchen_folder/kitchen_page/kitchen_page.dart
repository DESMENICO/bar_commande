import 'package:bar_commande/pages/kitchen_folder/kitchen_page/order_widget.dart';
import 'package:bar_commande/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../bloc/order_bloc.dart';
import '../../../models/order.dart';
import 'order_list_widget.dart';

class KitchenPage extends StatelessWidget {
  const KitchenPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cuisine")),
      body: Column(children: [
        const OrderListWidget(),
      ]),
    );
  }
}



