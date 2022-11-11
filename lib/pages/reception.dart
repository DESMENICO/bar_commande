import 'package:flutter/material.dart';

class Reception extends StatelessWidget{
  const Reception({super.key});
  
 
 @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acceuil"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: ElevatedButton(
                      onPressed: () {}, 
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance_wallet, size: MediaQuery.of(context).size.width * 0.05),
                          Text("COMMANDE",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),),
                          Icon(Icons.account_balance_wallet, size: MediaQuery.of(context).size.width * 0.05),
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
                children:  [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: ElevatedButton(
                      onPressed: () {},
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.coffee, size: MediaQuery.of(context).size.width * 0.05,),
                          Text("CUISINE",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),),
                          Icon(Icons.coffee, size: MediaQuery.of(context).size.width * 0.05,),
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
                      onPressed: () {}, 
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.tv, size: MediaQuery.of(context).size.width * 0.05),
                          Text("AFFICHAGE",style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),),
                          Icon(Icons.tv, size: MediaQuery.of(context).size.width * 0.05),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ], )
        ),
      );
    }
  }
   


