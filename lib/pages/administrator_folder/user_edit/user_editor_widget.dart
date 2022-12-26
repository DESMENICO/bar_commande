
import 'package:bar_commande/models/user.dart';
import 'package:bar_commande/pages/administrator_folder/user_edit/user_editor_page.dart';
import 'package:flutter/material.dart';

import '../../../services/authentifcation_service.dart';
import '../../../services/firestore_service.dart';

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