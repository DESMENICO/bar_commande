import 'package:bar_commande/pages/administrator_folder/user_edit/user_editor_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/user.dart';

class UsersListEditorWidget extends StatelessWidget {
  const UsersListEditorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('User').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
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
                  return UserEditorWidget(
                      User.edit(name, isAdmin, email, id, password));
                });
          }
        });
  }
}
