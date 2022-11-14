class Item{
  final String _name;
  final double _price;
  final bool _isFood;
  final String _description;
  bool _available = true;
  int _number = 0;

  Item(this._name,this._price,this._isFood,this._description,this._available);

  String get name => _name;
  double get price => _price;
  bool get isFood => _isFood;
  String get description => _description;
  bool get isAvailable => _available;
  int get number => _number;

  set available(bool value) => _available = value;
  set number(int value) => _number = value;
}