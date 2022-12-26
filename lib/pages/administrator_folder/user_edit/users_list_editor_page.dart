import 'package:bar_commande/models/user.dart';
import 'package:bar_commande/pages/administrator_folder/user_edit/user_editor_page.dart';
import 'package:bar_commande/pages/administrator_folder/user_edit/user_list_widget.dart';
import 'package:flutter/material.dart';

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

