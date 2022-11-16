import 'order.dart';

class OrderList{
  final List<Order> _commandes = <Order>[];

  OrderList(){
    /*_commandes.add(Order("Mathis"));
    _commandes.add(Order("Thibaut"));
    _commandes.add(Order("Nicolas"));*/
  }

    List<Order> get commandesList => _commandes;
}