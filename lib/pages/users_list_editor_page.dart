import 'package:bar_commande/pages/user_editor_page.dart';
import 'package:bar_commande/services/authentifcation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/firestore_service.dart';

class UsersListEditor extends StatefulWidget {
  const UsersListEditor({super.key});

  @override
  State<UsersListEditor> createState() => _UsersListEditorState();
}

class _UsersListEditorState extends State<UsersListEditor> {
  _UsersListEditorState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editeur d'utilisateurs"),
      ),
      body: const UsersListEditorWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserEditor(User("Nouvel utilisateur"),true),
            ),
          );
        },
        tooltip: 'Ajouter un utilisateur',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class UsersListEditorWidget extends StatelessWidget {

  const UsersListEditorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('User').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child:CircularProgressIndicator(),
            );
          } else {
            var snap = snapshot.data!.docs;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snap.length,
                itemBuilder: (context, int index) {
                  String name = snap[index]['name'];
                  bool isAdmin = snap[index]['isAdmin'];
                  String email = snap[index]['email'];
                  String password = snap[index]['password'];
                  String id = snap[index].id;
                  return UserEditorWidget(User.edit(name, isAdmin, email,id,password));
                });
          }
        });
  }
}

class UserEditorWidget extends StatefulWidget {
  final User user;

  const UserEditorWidget(this.user, {super.key});

  @override
  State<UserEditorWidget> createState() => _UserEditorWidgetState();
}

class _UserEditorWidgetState extends State<UserEditorWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: InkWell(
        onTap: () {
           Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              UserEditor(widget.user,false),
                        ),
                      );
        },
        child: Card(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.user.name,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async{
                DataBase database = DataBase();
                AuthentificationService auth = AuthentificationService();
                await auth.removeUser(widget.user);
                await database.deleteUser(widget.user);
              },
            )
          ]),
        ),
      ),
    );
  }
}
