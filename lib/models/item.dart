import 'package:uuid/uuid.dart';

class Item{
  var uuid = const Uuid();
  late String  _id;
  String _name;
  double _price;
  bool _isFood;
  bool _available = true;

  Item(this._name,this._price,this._isFood,this._available){
    _id = uuid.v4();
  }

  
  Item.update(this._id,this._name,this._price,this._isFood,this._available);

  String get name => _name;
  double get price => _price;
  bool get isFood => _isFood;
  bool get isAvailable => _available;
  String get id => _id;

  //set available(bool value) => _available = value;
  set isAvailable(bool value) => _available = value;
  set name(String value) => _name = value;
  set price(double value) => _price = value;
  set isFood(bool value) => _isFood = value;
  set id(String value) => _id = value;
}