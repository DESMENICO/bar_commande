import 'package:bar_commande/models/item.dart';

class ItemEvent {}

class AddItemEvent extends ItemEvent{
  final Item item;
  AddItemEvent(this.item);
}

class RemoveItemEvent extends ItemEvent{
  final Item item;
  RemoveItemEvent(this.item);
}

class UpdateItemEvent extends ItemEvent{
  final Item item;
  UpdateItemEvent(this.item);
}