class Item{
  final String _name;
  final double _price;
  final bool _isFood;
  final String _description;
  bool _available = true;

  Item(this._name,this._price,this._isFood,this._description,this._available);

  String get name => _name;
  double get price => _price;
  bool get isFood => _isFood;
  String get description => _description;
  bool get isAvailable => _available;

  set available(bool value) => _available = value;
}