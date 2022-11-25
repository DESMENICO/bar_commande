import 'package:uuid/uuid.dart';
import 'item.dart';

class Order{
  var uuid = const Uuid();
  String  _id = '';
  String _customer;// ="hgdfgukjgkjgjkqf";
  String _sellerId="hgdfgukjgkjgjkqf";
  bool finish = false;
  bool _drinkFinish = true;
  bool _foodFinish = true;
  late double _totalPrice = 0;


  List<Item> _itemList = <Item>[];//liste littérale = liste dont la taille n'est pas renseigné (d'apres la documentation officiel de dart )
  //https://dart.dev/tools/diagnostic-messages?utm_source=dartdev&utm_medium=redir&utm_id=diagcode&utm_content=default_list_constructor#default_list_constructor
  
  Order(this._customer){
    _id = uuid.v4();
    _foodFinish = false;
    _drinkFinish = false;    
    }
  Order.kitchen(this._customer, this._drinkFinish, this._foodFinish, this._id, this._totalPrice){
    _id = uuid.v4();
    _foodFinish = false;
    _drinkFinish = false;    
    }
  
  
  void checkFoodAndDrink(){
    for (var item in _itemList) {
      if(item.isFood){
        _foodFinish = false;
      }else{
        _drinkFinish = false;
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
  bool get foodFinish => _foodFinish;
  bool get drinkFinish => _drinkFinish;
  String get customer => _customer;
  set customer(String value) => _customer = value;   
  set totalPrice(double value) => _totalPrice = value;
  set foodFinish(bool value) => _foodFinish = value;
  set drinkFinish(bool value) => _drinkFinish = value;
  


  void updateTotal() {
    totalPrice = 0;
    for(Item item in _itemList){
      totalPrice += item.price;
    }
  }
  



}