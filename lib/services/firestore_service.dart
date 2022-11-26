import 'package:bar_commande/models/item.dart';
import 'package:bar_commande/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {
  DataBase();

  final CollectionReference itemCollection = FirebaseFirestore.instance.collection("Item");
  final CollectionReference orderCurrentCollection = FirebaseFirestore.instance.collection("CurrentOrder");
  final CollectionReference orderCollection = FirebaseFirestore.instance.collection("Order");
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("User");



  Future<void> addCurrentOrder(Order order) async {
    Map<String,dynamic> orderToSend = {
    "id":order.id,
    "containFood": order.containFood,
    "containDrink": order.containDrink,
    "sellerId" : order.sellerId,
    "totalPrice" :order.totalPrice,
    "customer" : order.customer,
    };
    var document = await orderCurrentCollection.add(orderToSend);
    Map<String,dynamic> orderId ={
      "id": document.id
    };
    orderCurrentCollection.doc(document.id).update(orderId);
    for(Item item in order.itemList){
      await addItemInOrder(item, document.id,orderCurrentCollection);
    }
  }

  Future<void> addOrder(Order order) async {
    Map<String,dynamic> orderToSend = {
    "id" : order.id,
    "containFood": order.containFood,
    "containDrink": order.containDrink,
    "sellerId" : order.sellerId,
    "totalPrice" :order.totalPrice,
    "customer" : order.customer,
    "date": Timestamp.now(), 
    };
    var document = await orderCollection.add(orderToSend);
    Map<String,dynamic> orderId ={
      "id": document.id
    };
    orderCollection.doc(document.id).update(orderId);
    for(Item item in order.itemList){
      await addItemInOrder(item, document.id,orderCollection);
    }
  }


  Future<void> updateItemList(Order order)async{
    await orderCurrentCollection.doc(order.id).collection('Item').get().then((snapshot) {
    for (DocumentSnapshot doc in snapshot.docs) {
    doc.reference.delete();
    }});


    for(Item item in order.itemList){
      addItemInOrder(item, order.id, orderCurrentCollection);
    }

  }

  Future<void> deleteCurrentOrder(Order order) async{
    orderCurrentCollection.doc(order.id).delete();
  }


  Future<void> addItemInOrder(Item item,String id,CollectionReference collectionReference) async {
    Map<String,dynamic> itemToAdd = {
      "name":item.name,
      "price":item.price,
      "isFood":item.isFood,
      "available":item.isAvailable
    };
    collectionReference.doc(id).collection('Item').add(itemToAdd);
  }

  Future<void> updateOrder(Order order) async{
    Map<String,dynamic> orderUpdate ={
      "containFood": order.containFood,
      "containDrink" : order.containDrink
    };
    orderCurrentCollection.doc(order.id).update(orderUpdate);
  }


  Future<List<Item>> getItemList(String? docId) async {
    List<Item> itemList = [];
    QuerySnapshot feed = await orderCurrentCollection.doc(docId).collection("Item").get();
      for (var itemdoc in feed.docs ) {
        var name = itemdoc['name'];
        var price = itemdoc['price'];
        var isFood = itemdoc['isFood'];
        var isAvailable = itemdoc['available'];
        Item item = Item(name, price.toDouble(), isFood, isAvailable);
        itemList.add(item);
      }
    return itemList;
  }

Future<Map<String,dynamic>> getUserInformation(String userId) async{
  DocumentSnapshot<Object?> information = await userCollection.doc(userId).get();
  
  Map<String,dynamic> map ={
    "name": information["name"],
    "isAdmin": information["isAdmin"]
  };
  return map;
}







  /*Future<void> saveUser(String name, double price, bool isFood, bool isAvailable,String docName) async {
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
  }*/
}