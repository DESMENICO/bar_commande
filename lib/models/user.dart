import 'package:uuid/uuid.dart';

class User {
  var uuid = const Uuid();
  late String _id;
  String name = " ";
  String email = "";
  String password = "";
  bool isAdmin = false;

  User(
    this.name,
  ) {
    _id = uuid.v4();
  }
  User.edit(this.name, this.isAdmin, this.email, this._id, this.password);
  User.auth(this._id);
  String get id => _id;
}
