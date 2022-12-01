import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'item.dart';
import 'package:tuple/tuple.dart';

class Order{
  var uuid = const Uuid();
  String  _id = '';
  String _customer;
  String _sellerId="hgdfgukjgkjgjkqf";
  bool _finish = false;
  bool _containDrink = true;
  bool _containFood = true;
  late DateTime _date;
  late double _totalPrice = 0;
  bool _isOnScreen = false;
  List<String> _itemUsed = [];


  List<Item> _itemList = <Item>[];//liste littérale = liste dont la taille n'est pas renseigné (d'apres la documentation officiel de dart )
  //https://dart.dev/tools/diagnostic-messages?utm_source=dartdev&utm_medium=redir&utm_id=diagcode&utm_content=default_list_constructor#default_list_constructor
  
  Order(this._customer){
    _id = uuid.v4();
    _containFood = false;
    _containDrink = false; 
    _date = DateTime.now();   
    }

  Order.kitchen(this._customer, this._containDrink, this._containFood, this._id, this._totalPrice,this._date);
  Order.television(this._customer,this._containDrink,this._containFood,this._date,this._finish,this._isOnScreen);
  Order.statistic(this._customer,this._totalPrice,this._sellerId,this._date,this._itemUsed);

    
  
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

  void removeFoodItem(){
    _itemList = _itemList.where((element) => !element.isFood).toList();
    /*for(Item item in _itemList){
      if(item.isFood){
        _itemList.remove(item);
      }
    }*/
  }

  void removeDrinkItem(){
    _itemList = _itemList.where((element) => element.isFood).toList();

/*for(var i = _itemList.length - 1; i >= 0; i--){
  var item = _itemList[i];
      if(!item.isFood){
        _itemList.remove(item);
      }
    }*/
  }
  


  bool isInsideAList(Item item,List<Item> list){
    for(Item itemInList in list){
    if(itemInList.name == item.name){
      return true;
      }
    }
  return false;
  }

  int getItemNumber(Item item){
    int number = 0;
    for(Item itemInList in _itemList){
        if(itemInList.name==item.name){
          number++;
        }
    }
    return number;
  }
  List<String> get itemUsed => _itemUsed;
  String get id => _id;
  String get sellerId => _sellerId;
  List<Item> get itemList => _itemList;
  double get totalPrice => _totalPrice;
  bool get containFood => _containFood;
  bool get containDrink => _containDrink;
  String get customer => _customer;
  bool get finish => _finish;
  DateTime get date => _date;
  bool get isOnScreen => _isOnScreen;
  set itemUsed(List<String> value)=> _itemUsed = value;
  set sellerId(String value)=> _sellerId = value;
  set itemList(List<Item> value) => _itemList = value;
  set customer(String value) => _customer = value;   
  set totalPrice(double value) => _totalPrice = value;
  set containFood(bool value) => _containFood = value;
  set containDrink(bool value) => _containDrink = value;
  set date(DateTime value) => _date = value;
  set finish(bool value)=> _finish = value;
  set isOnScreen(bool value)=> _isOnScreen=value;


  void updateTotal() {
    checkFoodAndDrink();
    totalPrice = 0;
    for(Item item in _itemList){
      totalPrice += item.price;
    }
  }

  Tuple2<List<int>,List<Item>>  getItemListSummary(){
    List<int> itemNumber = [];
    List<Item> itemList = [];

    for(Item item in _itemList){
      if(!isInsideAList(item, itemList)){
        itemList.add(item);
        itemNumber.add(getItemNumber(item));
      }
    }
    return Tuple2(itemNumber, itemList);
  }
  



}