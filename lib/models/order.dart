import 'package:uuid/uuid.dart';
import 'item.dart';

class Order{
  var uuid = const Uuid();
  String  _id = '';
  String _customer;// ="hgdfgukjgkjgjkqf";
  String _sellerId="hgdfgukjgkjgjkqf";
  String? _waiterDrinkId;
  String? _waiterFoodId;
  bool finish = false;
  bool _drinkFinish = true;
  bool _foodFinish = true;
  double _totalPrice = 0;
  List<Item> _itemList = <Item>[];//liste littérale = liste dont la taille n'est pas renseigné (d'apres la documentation officiel de dart )
  //https://dart.dev/tools/diagnostic-messages?utm_source=dartdev&utm_medium=redir&utm_id=diagcode&utm_content=default_list_constructor#default_list_constructor

  Order(this._customer,this._itemList){
    _id = uuid.v4();
    
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
  }

  List<Item> get itemList => _itemList;
  double get totalPrice => _totalPrice;

  String get customer => _customer;
  set customer(String value) => _customer = value;   
  set totalPrice(double value) => _totalPrice = value;
  



}