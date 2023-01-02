import 'package:uuid/uuid.dart';

class Item {
  final _uuid = const Uuid();
  late String id;
  String name;
  double price;
  bool isFood;
  bool isAvailable = true;

  Item(this.name, this.price, this.isFood, this.isAvailable) {
    id = _uuid.v4();
  }

  Item.update(this.id, this.name, this.price, this.isFood, this.isAvailable);
}
