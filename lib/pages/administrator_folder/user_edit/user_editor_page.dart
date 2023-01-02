import 'package:bar_commande/models/user.dart';
import 'package:bar_commande/services/authentifcation_service.dart';
import 'package:flutter/material.dart';

import '../../../services/firestore_service.dart';

class UserEditor extends StatefulWidget {
  final User _user;
  final bool _isNew;
  const UserEditor(this._user,this._isNew, {super.key});

  @override
  UserEditorState createState() {
    return UserEditorState();
  }
}

class UserEditorState extends State<UserEditor> {
  final _formKey = GlobalKey<FormState>();
  late String _password;
  @override
  Widget build(BuildContext context) {
    String? newPassword;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edition de  ${widget._user.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                  initialValue: widget._user.name,
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
                    widget._user.name = value!;
                  }),
              TextFormField(
                initialValue: widget._user.email,
                decoration: const InputDecoration(
                    labelText: "Entrer l'adresse email de l'utilisateur",
                    icon: Icon(Icons.alternate_email)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez mettre une adresse email valide";
                  }
                  return null;
                },
                onSaved: (value) {
                    widget._user.email = value!;
                  }
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "Entrer le mot de passe",
                    icon: Icon(Icons.password)),
                validator: (value) {
                  newPassword = value;
                  if (value != null && value.length < 6) {
                    return "Veuillez mettre un mot de passe composé de 6 caractères minimum";
                  }
                  return null;
                },
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
                onSaved: (value) {
                    _password = value!;
                  }
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.admin_panel_settings),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Switch(
                          value: widget._user.isAdmin,
                          onChanged: (value) {
                            setState(() {
                              widget._user.isAdmin=value;
                            });
                          }),
                    ),
                    const Text('Administrateur'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    
                  AuthentificationService auth = AuthentificationService();
                  DataBase database = DataBase();
                  if(!widget._isNew){
                    await auth.removeUser(widget._user);
                    await database.deleteUser(widget._user);
                  }
                    User temp = await auth.createUser(widget._user.email, _password);
                    temp.email = widget._user.email;
                    temp.name = widget._user.name;
                    temp.isAdmin = widget._user.isAdmin;
                    temp.password = _password;
                    database.addUser(temp);
                    if (!mounted) return;
                    Navigator.pop(context);
                }},
                child: const Text("Sauvegarder"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
