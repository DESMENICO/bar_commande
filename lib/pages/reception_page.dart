import 'package:bar_commande/pages/administrator_page.dart';
import 'package:bar_commande/pages/order_page.dart';
import 'package:bar_commande/pages/kitchen_page.dart';
import 'package:bar_commande/pages/television_page.dart';
import 'package:flutter/material.dart';

import '../bloc/item_bloc.dart';
import '../bloc/order_bloc.dart';
import '../models/user.dart';

class Reception extends StatelessWidget {
  ItemBloc itemBloc;
  OrderBloc orderBloc;
  User user;
  Reception(this.itemBloc, this.orderBloc,this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Acceuil"), automaticallyImplyLeading: false),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderPage(itemBloc, orderBloc,user),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_balance_wallet,
                            size: MediaQuery.of(context).size.width * 0.05),
                        Text(
                          "COMMANDE",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                        ),
                        Icon(Icons.account_balance_wallet,
                            size: MediaQuery.of(context).size.width * 0.05),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: ElevatedButton(
                    onPressed: () async {
                      var response = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              KitchenPage(itemBloc, orderBloc),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.coffee,
                          size: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Text(
                          "CUISINE",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                        ),
                        Icon(
                          Icons.coffee,
                          size: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              TelevisionPage(),
                        ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.tv,
                            size: MediaQuery.of(context).size.width * 0.05),
                        Text(
                          "AFFICHAGE",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                        ),
                        Icon(Icons.tv,
                            size: MediaQuery.of(context).size.width * 0.05),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: user.isAdmin,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const AdministratorPage(),
                        ),
                      );
                    },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.admin_panel_settings,
                              size: MediaQuery.of(context).size.width * 0.05),
                          Text(
                            "ADMINISTRATION",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                          Icon(Icons.admin_panel_settings,
                              size: MediaQuery.of(context).size.width * 0.05),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
