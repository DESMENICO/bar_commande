class Item{
  final String _name;
  final double _price;
  final bool _isFood;
  final String _description;
  bool available; 

  Item(this._name,this._price,this._isFood,this._description,this.available);

  String get name => _name;

  double get price => _price;
  bool get isFood => _isFood;
  String get description => _description;
  //ggdghgdfsgtdgd
}