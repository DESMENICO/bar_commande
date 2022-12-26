import 'package:bar_commande/models/order.dart';
import 'package:bar_commande/services/firestore_service.dart';
import 'package:flutter/material.dart';

class SummaryOrderBottomBarWidget extends StatefulWidget {
  final Order order;

  const SummaryOrderBottomBarWidget(this.order, {super.key});

  @override
  State<SummaryOrderBottomBarWidget> createState() => _SummaryOrderBottomBarWidgetState();
}

class _SummaryOrderBottomBarWidgetState extends State<SummaryOrderBottomBarWidget> {
   DataBase dataBase = DataBase();

  void deleteOrderFromScreenWithDelay() async{
      Future.delayed(const Duration(seconds: 5),((() async{
      widget.order.isOnScreen = false;
      await dataBase.updateOrder(widget.order);
      if(widget.order.finish){
      await dataBase.deleteCurrentOrder(widget.order);
    }
    })));
    
  }

  void _setDrinkFinish() async {
    setState(() {
      widget.order.containDrink = false;
    });
    widget.order.removeDrinkItem();
        
    if (!widget.order.containDrink && !widget.order.containFood) {
      widget.order.finish = true;
      if(!widget.order.isOnScreen){
      await dataBase.deleteCurrentOrder(widget.order);
      }
    }
     await dataBase.removeFinishedOrder(widget.order);
    if (!widget.order.containFood) {
      Navigator.pop(context);
    }
    await dataBase.updateItemList(widget.order);
    await dataBase.updateOrder(widget.order);
  }

  

  void _setFoodFinish() async {
    setState(() {
      widget.order.containFood = false;
    });
    widget.order.removeFoodItem();    
    widget.order.isOnScreen = true;
    if (!widget.order.containDrink && !widget.order.containFood) {
      widget.order.finish = true;
    }
    await dataBase.updateItemList(widget.order);
    await dataBase.updateOrder(widget.order);
    if (!widget.order.containDrink) {
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
          visible: widget.order.containFood,
          child: ElevatedButton(
            onPressed: _setFoodFinish,
            child: const Text(
              "Servir Nourriture",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Visibility(
          visible: widget.order.containDrink,
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