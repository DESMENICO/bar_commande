import 'package:bar_commande/bloc/item_events.dart';
import 'package:bar_commande/bloc/item_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/item.dart';

class ItemBloc extends Bloc<ItemEvent,ItemState>{
  ItemBloc(List<Item> items) : super(ItemState(items)) {
    on<AddItemEvent>((event, emit) {
      List<Item> items = List.from(state.items);
      items.add(event.item);
      emit(ItemState(items));
    });


    on<UpdateItemEvent>((event, emit) => emit(ItemState(state.items)));


    on<RemoveItemEvent>((event, emit) {
      List<Item> items = List.from(state.items);
      items.remove(event.item);
      emit(ItemState(items));
    });

  }
  
}