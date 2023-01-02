import 'package:bar_commande/bloc/order_bloc.dart';
import 'package:bar_commande/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_form_widget.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  late OrderBloc _orderBloc;

  @override
  void initState() {
    super.initState();
    List<Order> orders = List.generate(2, (index) => Order("Client$index"));
    _orderBloc = OrderBloc(orders);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderBloc>.value(
      value: _orderBloc,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
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
                    children: const [LoginFormWidget()]),
              ))),
    );
  }
}

