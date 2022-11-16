import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/order.dart';
import 'order_events.dart';
import 'order_states.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc(List<Order> orders) : super(OrderState(orders)) {
    on<AddOrderEvent>((event, emit) {
      List<Order> orders = List.from(state.orders);
      orders.add(event.order);
      emit(OrderState(orders));
    });
    on<RemoveOrderEvent>((event, emit) {
      List<Order> order = List.from(state.orders);
      order.remove(event.order);
      emit(OrderState(order));
    });
    on<UpdateOrderEvent>((event, emit) {
      emit(OrderState(state.orders));
    });
  }
}
