// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

import 'package:bar_commande/bloc/item_bloc.dart';
import 'package:bar_commande/bloc/order_bloc.dart';
import 'package:bar_commande/models/item.dart';
import 'package:bar_commande/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bar_commande/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
   List<Item> items = List.generate(
        10,
        (index) => Item("Item${Random().nextInt(10000)}", Random().nextDouble() * 2.5, false, "Ceci est une description", true));
  ItemBloc itemBloc = ItemBloc(items);

  List<Order> orders = List.generate(
        10,
        (index) => Order("Vendeur$index",items));
OrderBloc orderBloc = OrderBloc(orders);
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(itemBloc,orderBloc));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}*/
