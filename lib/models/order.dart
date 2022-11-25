import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'item.dart';

class Order{
  var uuid = const Uuid();
  String  _id = '';
  String _customer;// ="hgdfgukjgkjgjkqf";
  String _sellerId="hgdfgukjgkjgjkqf";
  bool finish = false;
  bool _containDrink = true;
  bool _containFood = true;
  late double _totalPrice = 0;


  List<Item> _itemList = <Item>[];//liste littérale = liste dont la taille n'est pas renseigné (d'apres la documentation officiel de dart )
  //https://dart.dev/tools/diagnostic-messages?utm_source=dartdev&utm_medium=redir&utm_id=diagcode&utm_content=default_list_constructor#default_list_constructor
  
  Order(this._customer){
    _id = uuid.v4();
    _containFood = false;
    _containDrink = false;    
    }

  Order.kitchen(this._customer, this._containDrink, this._containFood, this._id, this._totalPrice);

    
  
  void checkFoodAndDrink(){
    for (var item in _itemList) {
      if(item.isFood){
        _containFood = true;
      }else{
        _containDrink = true;
      }
    }
  }

  void addItem(Item item){
    _itemList.add(item);
    updateTotal();
  }

  void removeItem(Item item){
    _itemList.remove(item);
    updateTotal();
  }


  bool isInsideAList(int index,List<Item> list){
    bool isInside = false;
    for(Item itemInList in list){
    if(itemInList == itemList[index]){
      isInside = true;
    }
  }
  return isInside;
  }

  int getItemNumber(Item item){
    int number = 0;
    for(Item itemInList in _itemList){
        if(itemInList==item){
          number++;
        }
    }
    return number;
  }

  Item getItemInList(int index){
    return _itemList[index];
  }

  String get id => _id;
  String get sellerId => _sellerId;
  List<Item> get itemList => _itemList;
  double get totalPrice => _totalPrice;
  bool get containFood => _containFood;
  bool get containDrink => _containDrink;
  String get customer => _customer;
  set itemList(List<Item> value) => _itemList = value;
  set customer(String value) => _customer = value;   
  set totalPrice(double value) => _totalPrice = value;
  set containFood(bool value) => _containFood = value;
  set containDrink(bool value) => _containDrink = value;
  


  void updateTotal() {
    checkFoodAndDrink();
    totalPrice = 0;
    for(Item item in _itemList){
      totalPrice += item.price;
    }
  }
  



}