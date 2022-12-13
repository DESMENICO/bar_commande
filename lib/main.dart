import 'package:bar_commande/bloc/item_bloc.dart';
import 'package:bar_commande/bloc/order_bloc.dart';
import 'package:bar_commande/models/item.dart';
import 'package:bar_commande/models/user.dart';
import 'package:bar_commande/pages/reception_page.dart';
import 'package:bar_commande/pages/television_page.dart';
import 'package:bar_commande/services/authentifcation_service.dart';
import 'package:bar_commande/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'models/order.dart';

void main() async {
 List<Item> items = List.generate(
        10,
        (index) => Item("Item${Random().nextInt(10000)}", (index.toDouble() * 1.5) + 1, false, true));
  ItemBloc itemBloc = ItemBloc(items);

List<Order> orders = List.generate(
        10,
        (index) => Order("Commande $index"));
OrderBloc orderBloc = OrderBloc(orders);

WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(itemBloc,orderBloc));
}




class MyApp extends StatefulWidget {
  ItemBloc itemBloc;
  OrderBloc orderBloc;
  MyApp(this.itemBloc, this.orderBloc, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderBloc>.value(value: widget.orderBloc),
        BlocProvider<ItemBloc>.value(value: widget.itemBloc),

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
                  children: [LoginForm(widget.itemBloc,widget.orderBloc)]),
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  @override
  void initState() {
    super.initState();
    _emailController.text = "";
    _passwordController.text = "";

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Entrer votre identifiant',
                icon: Icon(Icons.account_circle_sharp),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Entrez votre adresse email';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Entrer votre mot de passe',
                icon: Icon(Icons.key),
              ),
              validator: (value) {
                if (value != null && value.length < 6) {
                  return "Veuillez mettre un mot de passe composé de 6 caractères minimum";
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: ElevatedButton(
              onPressed: () async {
                DataBase dataBase = DataBase();
                AuthentificationService authentificationService = AuthentificationService();
                if(_formKey.currentState?.validate() == true){
                  var email = _emailController.value.text;
                  var password = _passwordController.value.text;
                  User user = await authentificationService.signinUser(email, password);
                  Map map = await dataBase.getUserInformation(user.id);
                  user.isAdmin = map["isAdmin"];
                  user.name = map["name"];
                  await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Reception(widget.itemBloc,widget.orderBloc,user),
                  ));
                }
              },
              child: const Text('Connexion'),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(50.0),
            child: ElevatedButton(
              onPressed: ()  {
                  Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Reception(widget.itemBloc,widget.orderBloc,User.edit("tff",true, " ","dfgh",'mdp')),
                  ));
                },
              child: const Text('Connexion admin'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: ElevatedButton(
              onPressed: ()  {
                  Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TelevisionPage())
                  );
                },
              child: const Text('Connexion Television'),
            ),
          ),
        ],
      ),
    );
  }
}
