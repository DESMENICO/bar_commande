import 'package:bar_commande/models/item.dart';
import 'package:bar_commande/models/order.dart';
import 'package:bar_commande/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {
  DataBase();

  final CollectionReference _itemCollection =
      FirebaseFirestore.instance.collection("Item");
  final CollectionReference _orderCurrentCollection =
      FirebaseFirestore.instance.collection("CurrentOrder");
  final CollectionReference _orderCollection =
      FirebaseFirestore.instance.collection("Order");
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection("User");

  Future<void> addCurrentOrder(Order order) async {
    Map<String, dynamic> orderToSend = {
      "id": order.id,
      "containFood": order.containFood,
      "containDrink": order.containDrink,
      "finish": false,
      "isOnScreen": false,
      "sellerId": order.sellerId,
      "totalPrice": order.totalPrice,
      "customer": order.customer,
      "date": Timestamp.now()
    };
    var document = await _orderCurrentCollection.add(orderToSend);
    Map<String, dynamic> orderId = {"id": document.id};
    _orderCurrentCollection.doc(document.id).update(orderId);
    for (Item item in order.itemList) {
      await addItemInOrder(item, document.id, _orderCurrentCollection);
    }
  }

  Future<void> addOrder(Order order) async {
    List<String> itemlist = [];
    for (Item item in order.itemList) {
      itemlist.add(item.name);
    }
    Map<String, dynamic> orderToSend = {
      "id": order.id,
      "containFood": order.containFood,
      "containDrink": order.containDrink,
      "sellerId": order.sellerId,
      "totalPrice": order.totalPrice,
      "customer": order.customer,
      "items": itemlist,
      "date": Timestamp.now(),
    };
    var document = await _orderCollection.add(orderToSend);
    Map<String, dynamic> orderId = {"id": document.id};
    _orderCollection.doc(document.id).update(orderId);
    for (Item item in order.itemList) {
      //await updateItemUsed(item);
      await addItemInOrder(item, document.id, _orderCollection);
    }
  }

  Future<void> updateItemList(Order order) async {
    await _orderCurrentCollection
        .doc(order.id)
        .collection('Item')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    for (Item item in order.itemList) {
      addItemInOrder(item, order.id, _orderCurrentCollection);
    }
  }

  Future<void> deleteCurrentOrderCollection() async {
    var snapshots = await _orderCurrentCollection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> deleteCurrentOrder(Order order) async {
    _orderCurrentCollection.doc(order.id).delete();
  }

  Future<void> addItemInOrder(
      Item item, String id, CollectionReference collectionReference) async {
    Map<String, dynamic> itemToAdd = {
      "name": item.name,
      "price": item.price,
      "isFood": item.isFood,
      "available": item.isAvailable
    };
    collectionReference.doc(id).collection('Item').add(itemToAdd);
  }

  Future<void> updateOrder(Order order) async {
    Map<String, dynamic> orderUpdate = {
      "containFood": order.containFood,
      "containDrink": order.containDrink,
      "finish": order.finish,
      "isOnScreen": order.isOnScreen
    };
    _orderCurrentCollection.doc(order.id).update(orderUpdate);
  }

  Future<List<Item>> getItemList(String? docId) async {
    List<Item> itemList = [];
    QuerySnapshot feed =
        await _orderCurrentCollection.doc(docId).collection("Item").get();
    for (var itemdoc in feed.docs) {
      var name = itemdoc['name'];
      var price = itemdoc['price'];
      var isFood = itemdoc['isFood'];
      var isAvailable = itemdoc['available'];
      Item item = Item(name, price.toDouble(), isFood, isAvailable);
      itemList.add(item);
    }
    return itemList;
  }

  Future<Map<String, dynamic>> getUserInformation(String userId) async {
    DocumentSnapshot<Object?> information =
        await _userCollection.doc(userId).get();

    Map<String, dynamic> map = {
      "name": information["name"],
      "isAdmin": information["isAdmin"]
    };
    return map;
  }

  updateItem(Item item) async {
    var doc = await _itemCollection.doc(item.id).get();
    if (!doc.exists) {
      addItem(item);
    } else {
      Map<String, dynamic> itemUpdate = {
        "name": item.name,
        "price": item.price,
        "isFood": item.isFood,
        "available": item.isAvailable
      };
      _itemCollection.doc(item.id).update(itemUpdate);
    }
  }

  Future<void> addItem(Item item) async {
    Map<String, dynamic> itemToSend = {
      "id": item.id,
      "name": item.name,
      "price": item.price,
      "isFood": item.isFood,
      "available": item.isAvailable
    };
    var document = await _itemCollection.add(itemToSend);
    Map<String, dynamic> itemId = {"id": document.id};
    _itemCollection.doc(document.id).update(itemId);
  }

  deleteItem(Item item) {
    _itemCollection.doc(item.id).delete();
  }

  updateUserCollection(User user) async {
    var doc = await _userCollection.doc(user.id).get();
    if (!doc.exists) {
      addUser(user);
    } else {
      Map<String, dynamic> userUpdate = {
        "name": user.name,
        "email": user.email,
        "isAdmin": user.isAdmin,
      };
      _userCollection.doc(user.id).update(userUpdate);
    }
  }

  void addUser(User user) async {
    Map<String, dynamic> userToSend = {
      "id": user.id,
      "name": user.name,
      "email": user.email,
      "isAdmin": user.isAdmin,
      "password": user.password
    };
    await _userCollection.doc(user.id).set(userToSend);
  }

  deleteUser(User user) async {
    await _userCollection.doc(user.id).delete();
  }
}
