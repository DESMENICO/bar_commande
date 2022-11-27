import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';

class UserEditor extends StatefulWidget {
  User user;

  UserEditor(this.user, {super.key});

  @override
  UserEditorState createState() {
    return UserEditorState();
  }
}

class UserEditorState extends State<UserEditor> {
  final _formKey = GlobalKey<FormState>();
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    //formattedDate = formatter.format(widget.crime.date);
    //dateController.text = formattedDate;
    isAdmin = widget.user.isAdmin;
  }

  @override
  Widget build(BuildContext context) {
    String? newPassword;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edition de  ${widget.user.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: widget.user.id,
                decoration: const InputDecoration(
                    labelText: 'Id', icon: Icon(Icons.key)),
                enabled: false,
              ),
              TextFormField(
                  initialValue: widget.user.name,
                  decoration: const InputDecoration(
                      labelText: "Entrer le nom de l'utilisateur",
                      icon: Icon(Icons.account_circle_sharp)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entrer un nom d'utilisateur svp";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.user.name = value!;
                  }),
              TextFormField(
                //initialValue: widget.user.name,
                decoration: const InputDecoration(
                    labelText: "Entrer l'adresse email de l'utilisateur",
                    icon: Icon(Icons.alternate_email)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez mettre une adresse email valide";
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "Entrer le nouveau mot de passe",
                    icon: Icon(Icons.password)),
                validator: (value) {
                  newPassword = value;
                  if (value != null && value.length < 6) {
                    return "Veuillez mettre un mot de passe composé de 6 caractères minimum";
                  }
                  return null;
                },
                /*onSaved: (value) {
                    widget.crime.date = formatter.parse(value!);
                  }*/
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "Confirmer le mot de passe",
                    icon: Icon(Icons.password)),
                validator: (value) {
                  if (value == null || value.isEmpty || value != newPassword) {
                    return "Les mots de passe ne correspondent pas";
                  }
                  return null;
                },
                /*onSaved: (value) {
                    widget.crime.date = formatter.parse(value!);
                  }*/
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.admin_panel_settings),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Switch(
                          value: isAdmin,
                          onChanged: (value) {
                            setState(() {
                              isAdmin = value;
                            });
                          }),
                    ),
                    const Text('Administrateur'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.user.isAdmin = isAdmin;
                    Navigator.pop(context);
                  }
                },
                child: const Text("Sauvegarder"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
