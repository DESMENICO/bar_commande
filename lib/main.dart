import 'package:bar_commande/bloc/item_bloc.dart';
import 'package:bar_commande/bloc/order_bloc.dart';
import 'package:bar_commande/models/item.dart';
import 'package:bar_commande/pages/reception_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';

import 'models/order.dart';

void main() async {
 List<Item> items = List.generate(
        10,
        (index) => Item("Item${Random().nextInt(10000)}", (index.toDouble() * 1.5) + 1, false, "Ceci est une description", true));
  ItemBloc itemBloc = ItemBloc(items);

List<Order> orders = List.generate(
        10,
        (index) => Order("Commende $index"));
OrderBloc orderBloc = OrderBloc(orders);

WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
  runApp(MyApp(itemBloc,orderBloc));
}




class MyApp extends StatelessWidget {
  ItemBloc itemBloc;
  OrderBloc orderBloc;
  MyApp(this.itemBloc, this.orderBloc, {super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderBloc>.value(value: orderBloc),
        BlocProvider<ItemBloc>.value(value: itemBloc),

      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
                .copyWith(secondary: Colors.grey)),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Page de connexion'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [LoginForm(itemBloc,orderBloc)]),
            ))));
  }
}

class LoginForm extends StatefulWidget {

   ItemBloc itemBloc;
  OrderBloc orderBloc;

  LoginForm(this.itemBloc,this.orderBloc,{super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Entrer votre identifiant',
                icon: Icon(Icons.account_circle_sharp),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Entrer votre mot de passe',
                icon: Icon(Icons.key),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: ElevatedButton(
              onPressed: () async {
                var response = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Reception(widget.itemBloc,widget.orderBloc),
                  ),
                );
              },
              child: const Text('Connexion'),
            ),
          ),
        ],
      ),
    );
  }
}
