import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class User{
  var uuid = const Uuid();
  late String _id;
  String _name = " ";
  String _email = "";
  String _password= "";
  bool _isAdmin = false;
  bool _isTelevision = false;

  User(this._name,)
  {
    _id = uuid.v4();
  }
  User.edit(this._name, this._isAdmin, this._email, this._id,this._password){
  }
  User.auth(this._id);
  String get name => _name;
  bool get isAdmin => _isAdmin;
  String get id => _id;
  String get email => _email;
  String get password => _password;
  set name(String value)=>_name = value;
  set isAdmin(bool value)=>_isAdmin = value;
  set email(String value)=>_email = value;
  set password(String value)=>_password = value;

}