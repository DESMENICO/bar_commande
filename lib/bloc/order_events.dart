import '../models/order.dart';

class OrderEvent {}

class AddOrderEvent extends OrderEvent {
  final Order order;

  AddOrderEvent(this.order);
}

class RemoveOrderEvent extends OrderEvent {
  final Order order;

  RemoveOrderEvent(this.order);
}

class UpdateOrderEvent extends OrderEvent {
  final Order order;

  UpdateOrderEvent(this.order);
}
