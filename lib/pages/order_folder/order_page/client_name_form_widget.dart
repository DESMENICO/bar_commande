import 'package:bar_commande/bloc/order_bloc.dart';
import 'package:bar_commande/bloc/order_events.dart';
import 'package:bar_commande/bloc/order_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bar_commande/models/order.dart' as models;

class ClientNameForms extends StatefulWidget {
  final models.Order order;
  const ClientNameForms(this.order, {super.key});

  @override
  State<ClientNameForms> createState() => _ClientNameFormsState();
}

class _ClientNameFormsState extends State<ClientNameForms> {

  final _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc,OrderState>(
      builder: (context, state) {
        if(widget.order.customer == "Nouveau Client"){
          _controller.clear();
        }
    return Form(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: _controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Entrer le nom du client',
          icon: Icon(Icons.person),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Entrer un nom de client svp';
          }
          return null;
        },
        onChanged: (value) {
          widget.order.customer = value;
          context.read<OrderBloc>().add(UpdateOrderEvent(widget.order));
        },
      ),
      ),
      );
      },
    
    );
  }
}