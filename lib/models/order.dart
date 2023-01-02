import 'package:uuid/uuid.dart';
import 'item.dart';
import 'package:tuple/tuple.dart';

class Order {
  var uuid = const Uuid();
  String _id = '';
  String customer;
  String sellerId = "";
  bool finish = false;
  bool containDrink = true;
  bool containFood = true;
  late DateTime date;
  double totalPrice = 0;
  bool isOnScreen = false;
  List<String> itemUsed = [];

  List<Item> itemList = <Item>[];
  Order(this.customer) {
    _id = uuid.v4();
    containFood = false;
    containDrink = false;
    date = DateTime.now();
  }

  Order.kitchen(this.customer, this.containDrink, this.containFood, this._id,
      this.totalPrice, this.date);
  Order.television(this.customer, this.containDrink, this.containFood,
      this.date, this.finish, this.isOnScreen);
  Order.statistic(
      this.customer, this.totalPrice, this.sellerId, this.date, this.itemUsed);

  void checkFoodAndDrink() {
    for (var item in itemList) {
      if (item.isFood) {
        containFood = true;
      } else {
        containDrink = true;
      }
    }
  }

  void addItem(Item item) {
    itemList.add(item);
    updateTotal();
  }

  void removeItem(Item item) {
    for (Item itemInList in itemList) {
      if (itemInList.name == item.name) {
        itemList.remove(itemInList);
        updateTotal();
        return;
      }
    }
  }

  void removeFoodItem() {
    itemList = itemList.where((element) => !element.isFood).toList();
  }

  void removeDrinkItem() {
    itemList = itemList.where((element) => element.isFood).toList();
  }

  bool isInsideAList(Item item, List<Item> list) {
    for (Item itemInList in list) {
      if (itemInList.name == item.name) {
        return true;
      }
    }
    return false;
  }

  int getItemNumber(Item item) {
    int number = 0;
    for (Item itemInList in itemList) {
      if (itemInList.name == item.name) {
        number++;
      }
    }
    return number;
  }

  String get id => _id;

  void updateTotal() {
    checkFoodAndDrink();
    totalPrice = 0;
    for (Item item in itemList) {
      totalPrice += item.price;
    }
  }

  Tuple2<List<int>, List<Item>> getItemListSummary() {
    List<int> itemNumber = [];
    List<Item> tempItemList = [];

    for (Item item in itemList) {
      if (!isInsideAList(item, tempItemList)) {
        tempItemList.add(item);
        itemNumber.add(getItemNumber(item));
      }
    }
    return Tuple2(itemNumber, tempItemList);
  }
}
