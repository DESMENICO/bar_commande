import 'package:bar_commande/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemDataBase {
  ItemDataBase();

  final CollectionReference<Map<String, dynamic>> itemCollection = FirebaseFirestore.instance.collection("Item");

  Future<void> saveUser(String name, double price, bool isFood, bool isAvailable,String docName) async {
    return await itemCollection.doc(docName).set({
        'name' : name,
        'price':price,
        'isFood' : isFood,
        'available' : isAvailable
      });
  }

  Future<void> saveToken(String? token,String docName) async {
    return await itemCollection.doc(docName).update({'token': token});
  }

  Item _itemFromSnapchot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("user not found");
    String name = data['name'];
    double price = data['price'];
    bool isFood = data['isFood'];
    bool isAvailable = data['available'];
    return Item(name,price,isFood,isAvailable);
  }

  Stream<Item> item(String docName) {
    return itemCollection.doc(docName).snapshots().map(_itemFromSnapchot);
  }

  List<Item> _itemListFromSnapchot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _itemFromSnapchot
  (doc);
    }).toList();
  }

  Stream<List<Item>> get itemList {
    return itemCollection.snapshots().map(_itemListFromSnapchot);
  }
}