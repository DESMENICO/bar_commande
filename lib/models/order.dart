import 'package:uuid/uuid.dart';
import 'item.dart';

class Order{
  var uuid = const Uuid();
  String  _id = '';
  String _customer ="";
  String _sellerId;
  String? _waiterDrinkId;
  String? _waiterFoodId;
  bool finish = false;
  bool _drinkFinish = true;
  bool _foodFinish = true;
  double _totalPrice = 0;
  List<Item> _itemList = <Item>[];//liste littérale = liste dont la taille n'est pas renseigné (d'apres la documentation officiel de dart )
  //https://dart.dev/tools/diagnostic-messages?utm_source=dartdev&utm_medium=redir&utm_id=diagcode&utm_content=default_list_constructor#default_list_constructor

  Order(this._sellerId){
    _id = uuid.v4();
    _itemList.add(Item("Coca",2, true,"Cola", true));
  _itemList.add(Item("Fanta",1.8, true,"Orange", true));
  _itemList.add(Item("Jupiler",1.5, true,"Binouze", true));
  _itemList.add(Item("Tequila",1.2, true,"Sunrize", true));
_itemList.add(Item("Heineken",2.5, true,"Poltemp", true));
_itemList.add(Item("Coca",1.7, true,"Cola", true));
  _itemList.add(Item("Fanta",2, true,"Orange", true));
  _itemList.add(Item("Jupiler",2, true,"Binouze", true));
  _itemList.add(Item("Tequila",2, true,"Sunrize", true));
_itemList.add(Item("Heineken",2, true,"Poltemp", true));
_itemList.add(Item("Coca",2, true,"Cola", true));
  _itemList.add(Item("Fanta",2, true,"Orange", true));
  _itemList.add(Item("Jupiler",2, true,"Binouze", true));
  _itemList.add(Item("Tequila",2, true,"Sunrize", true));
_itemList.add(Item("Heineken",2, true,"Poltemp", true));
_itemList.add(Item("Coca",2, true,"Cola", true));
  _itemList.add(Item("Fanta",2, true,"Orange", true));
  _itemList.add(Item("Jupiler",2, true,"Binouze", true));
  _itemList.add(Item("Tequila",2, true,"Sunrize", true));
_itemList.add(Item("Heineken",2, true,"Poltemp", true));
_itemList.add(Item("Coca",2, true,"Cola", true));
  _itemList.add(Item("Fanta",2, true,"Orange", true));
  _itemList.add(Item("Jupiler",2, true,"Binouze", true));
  _itemList.add(Item("Tequila",2, true,"Sunrize", true));
_itemList.add(Item("Heineken",2, true,"Poltemp", true));
_itemList.add(Item("Coca",2, true,"Cola", true));
  _itemList.add(Item("Fanta",2, true,"Orange", true));
  _itemList.add(Item("Jupiler",2, true,"Binouze", true));
  _itemList.add(Item("Tequila",2, true,"Sunrize", true));
_itemList.add(Item("Heineken",2, true,"Poltemp", true));
_itemList.add(Item("Coca",2, true,"Cola", true));
  _itemList.add(Item("Fanta",2, true,"Orange", true));
  _itemList.add(Item("Jupiler",2, true,"Binouze", true));
  _itemList.add(Item("Tequila",2, true,"Sunrize", true));
_itemList.add(Item("Heineken",2, true,"Poltemp", true));
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