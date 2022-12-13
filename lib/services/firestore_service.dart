import 'package:bar_commande/models/item.dart';
import 'package:bar_commande/models/order.dart';
import 'package:bar_commande/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {
  DataBase();

  final CollectionReference itemCollection =
      FirebaseFirestore.instance.collection("Item");
  final CollectionReference orderCurrentCollection =
      FirebaseFirestore.instance.collection("CurrentOrder");
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection("Order");
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("User");
  final CollectionReference orderFinishedCollection =
      FirebaseFirestore.instance.collection("FinishedOrder");
  final CollectionReference itemUsedCollection =
      FirebaseFirestore.instance.collection("ItemUsed");

  Future<void> addFinishedOrder(Order order) async {
    Map<String, dynamic> orderToSend = {
      "id": order.id,
      "containFood": order.containFood,
      "containDrink": order.containDrink,
      "sellerId": order.sellerId,
      "totalPrice": order.totalPrice,
      "customer": order.customer,
      "date": Timestamp.now()
    };
    var document = await orderFinishedCollection.add(orderToSend);
    Map<String, dynamic> orderId = {"id": document.id};
    orderFinishedCollection.doc(document.id).update(orderId);
  }

  Future<void> removeFinishedOrder(Order order) async {
    orderFinishedCollection.doc(order.id).delete();
  }

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
    var document = await orderCurrentCollection.add(orderToSend);
    Map<String, dynamic> orderId = {"id": document.id};
    orderCurrentCollection.doc(document.id).update(orderId);
    for (Item item in order.itemList) {
      
      await addItemInOrder(item, document.id, orderCurrentCollection);
    }
  }

  Future<void> addOrder(Order order) async {
    List<String> itemlist = [];
    for(Item item in order.itemList){
      itemlist.add(item.name);
    }
    Map<String, dynamic> orderToSend = {
      "id": order.id,
      "containFood": order.containFood,
      "containDrink": order.containDrink,
      "sellerId": order.sellerId,
      "totalPrice": order.totalPrice,
      "customer": order.customer,
      "items":itemlist,
      "date": Timestamp.now(),
    };
    var document = await orderCollection.add(orderToSend);
    Map<String, dynamic> orderId = {"id": document.id};
    orderCollection.doc(document.id).update(orderId);
    for (Item item in order.itemList) {
      //await updateItemUsed(item);
      await addItemInOrder(item, document.id, orderCollection);
    }
  }

  Future<void> updateItemList(Order order) async {
    await orderCurrentCollection
        .doc(order.id)
        .collection('Item')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    for (Item item in order.itemList) {
      addItemInOrder(item, order.id, orderCurrentCollection);
    }
  }
  Future<void> deleteCurrentOrderCollection() async{
    var snapshots = await orderCurrentCollection.get();
    for(var doc in snapshots.docs){
      await doc.reference.delete();
    }
  }

  Future<void> deleteCurrentOrder(Order order) async {
    orderCurrentCollection.doc(order.id).delete();
  }

  Future<void> addItemInOrder(Item item, String id, CollectionReference collectionReference) async {
    Map<String, dynamic> itemToAdd = {
      "name": item.name,
      "price": item.price,
      "isFood": item.isFood,
      "available": item.isAvailable
    };
    collectionReference.doc(id).collection('Item').add(itemToAdd);
  }
  
  Future<int> getNumberOfItemUsed(Item item,String docId) async{
    DocumentSnapshot<Object?> doc = await itemUsedCollection.doc(docId).get();
    Map<String,dynamic> map = doc[item.id];
    if(map.containsKey(item.id)){
      return 0;
    }else{
      return 1;
    }
  }



    /*Future<void> updateItemUsed(Item item) async{
    DateTime dateNow = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    int number =await getNumberOfItemUsed(item, formatter.format(dateNow));
    /*var test = await itemUsedCollection.doc(formatter.format(dateNow)).get();
    if(!test.exists){
      itemUsedCollection.doc(formatter.format(dateNow)).set({});
    }*/
    /*await itemUsedCollection.doc(formatter.format(dateNow)).get().then((value) {
      Map map = value.data() as Map;
      if(map.containsKey(item.name)){
        number = map[item.name];
      }  
    });*/

      number++;
      Map<String,dynamic> addItemUsed = {
        item.id: {"name" : item.name, "number" : number},
      };
      /*
      var doc = await itemUsedCollection.doc(formatter.format(dateNow)).get();
      if(!doc.exists){
        itemUsedCollection.doc(formatter.format(dateNow)).set(addItemUsed);
      }else{
        itemUsedCollection.doc(formatter.format(dateNow)).update(addItemUsed);
      }*/
      itemUsedCollection.doc(formatter.format(dateNow)).set(addItemUsed,SetOptions(merge: true));
      
    }


  /*Future<void> updateItemUsed(Item item) async {
    
    int number = 0;
    await itemUsedCollection.doc(formatter.format(dateNow)).get().then((value) {
      Map map = value.data() as Map;
      if(map.containsKey(item.name)){
        number = map[item.name];
      }  
    });
    number++;
    Map<String, dynamic> itemUsedUpdate = {
      item.name : number
    };
    
    itemUsedCollection.doc(formatter.format(dateNow)).set({
      item.name : number
    },SetOptions(merge: true));

    var doc = await itemUsedCollection.doc(formatter.format(dateNow)).get();
    if(!doc.exists){
      itemUsedCollection.doc(formatter.format(dateNow)).set(itemUsedUpdate);
    }else{
      itemUsedCollection.doc(formatter.format(dateNow)).update(itemUsedUpdate);
      }
  }

  Future<List<Item>> getAllItem() async {
    List<Item> itemList = [];
        QuerySnapshot feed =
      await itemCollection.get();
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
    

  /*Future<int> getNumber(String name, String date) async {
    int number = 5;
    
    
  }*/*/*/

  Future<void> updateOrder(Order order) async {
    Map<String, dynamic> orderUpdate = {
      "containFood": order.containFood,
      "containDrink": order.containDrink,
      "finish": order.finish,
      "isOnScreen": order.isOnScreen
    };
    orderCurrentCollection.doc(order.id).update(orderUpdate);
  }

  Future<List<Item>> getItemList(String? docId) async {
    List<Item> itemList = [];
    QuerySnapshot feed =
        await orderCurrentCollection.doc(docId).collection("Item").get();
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
        await userCollection.doc(userId).get();

    Map<String, dynamic> map = {
      "name": information["name"],
      "isAdmin": information["isAdmin"]
    };
    return map;
  }

  updateItem(Item item) async {
    var doc = await itemCollection.doc(item.id).get();
    if (!doc.exists) {
      addItem(item);
    } else {
      Map<String, dynamic> itemUpdate = {
        "name": item.name,
        "price": item.price,
        "isFood": item.isFood,
        "available": item.isAvailable
      };
      itemCollection.doc(item.id).update(itemUpdate);
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
    var document = await itemCollection.add(itemToSend);
    Map<String, dynamic> itemId = {"id": document.id};
    itemCollection.doc(document.id).update(itemId);
    /*DateTime dateNow = DateTime.now();
     final DateFormat formatter = DateFormat('dd/MM/yyyy');
    Map<String,dynamic> itemToSendToItemUsed = {
      "id":document.id,
      "name":item.name,
      formatter.format(dateNow): 1,
    };
    itemUsedCollection.doc(document.id).set(itemToSendToItemUsed);*/
  }

  deleteItem(Item item) {
    itemCollection.doc(item.id).delete();
  }

  updateUserCollection(User user) async {
    var doc = await userCollection.doc(user.id).get();
    if (!doc.exists) {
      addUser(user);
    } else {
      Map<String, dynamic> userUpdate = {
        "name": user.name,
        "email": user.email,
        "isAdmin": user.isAdmin,
      };
      userCollection.doc(user.id).update(userUpdate);
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
    await userCollection.doc(user.id).set(userToSend);
  }

  deleteUser(User user) async{
   await userCollection.doc(user.id).delete();
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
