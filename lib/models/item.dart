class Item{
  final String _name;
  final double _price;
  final bool _isFood;
  bool _available = true;

  Item(this._name,this._price,this._isFood,this._available);

  String get name => _name;
  double get price => _price;
  bool get isFood => _isFood;
  bool get isAvailable => _available;

  set available(bool value) => _available = value;
}