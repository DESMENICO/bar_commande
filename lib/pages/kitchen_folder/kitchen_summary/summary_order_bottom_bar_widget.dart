import 'package:bar_commande/models/order.dart';
import 'package:bar_commande/services/firestore_service.dart';
import 'package:flutter/material.dart';

class SummaryOrderBottomBarWidget extends StatefulWidget {
  final Order _order;

  const SummaryOrderBottomBarWidget(this._order, {super.key});

  @override
  State<SummaryOrderBottomBarWidget> createState() => _SummaryOrderBottomBarWidgetState();
}

class _SummaryOrderBottomBarWidgetState extends State<SummaryOrderBottomBarWidget> {
   DataBase dataBase = DataBase();

  void deleteOrderFromScreenWithDelay() async{
      Future.delayed(const Duration(seconds: 5),((() async{
      widget._order.isOnScreen = false;
      await dataBase.updateOrder(widget._order);
      if(widget._order.finish){
      await dataBase.deleteCurrentOrder(widget._order);
    }
    })));
    
  }

  void _setDrinkFinish() async {
    setState(() {
      widget._order.containDrink = false;
    });
    widget._order.removeDrinkItem();
        
    if (!widget._order.containDrink && !widget._order.containFood) {
      widget._order.finish = true;
      if(!widget._order.isOnScreen){
      await dataBase.deleteCurrentOrder(widget._order);
      }
    }
    if (!widget._order.containFood) {
      if (!mounted) return;
      Navigator.pop(context);
    }
    await dataBase.updateItemList(widget._order);
    await dataBase.updateOrder(widget._order);
  }

  

  void _setFoodFinish() async {
    setState(() {
      widget._order.containFood = false;
    });
    widget._order.removeFoodItem();    
    widget._order.isOnScreen = true;
    if (!widget._order.containDrink && !widget._order.containFood) {
      widget._order.finish = true;
    }
    await dataBase.updateItemList(widget._order);
    await dataBase.updateOrder(widget._order);
    if (!widget._order.containDrink) {
      if (!mounted) return;
      Navigator.pop(context);
    }
    deleteOrderFromScreenWithDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Visibility(
          visible: widget._order.containFood,
          child: ElevatedButton(
            onPressed: _setFoodFinish,
            child: const Text(
              "Servir Nourriture",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Visibility(
          visible: widget._order.containDrink,
          child: ElevatedButton(
            onPressed: _setDrinkFinish,
            child: const Text(
              "Servir Boisson",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        )
      ]),
    );
  }
}