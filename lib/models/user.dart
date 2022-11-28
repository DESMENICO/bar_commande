import 'package:flutter/material.dart';

class User{
  String _id = 'dfdfs';
  String _name ;
  bool _isAdmin = false;
  bool _isTelevision = false;

  User(this._name,);
  User.edit(this._name, this._isAdmin);
  String get name => _name;
  bool get isAdmin => _isAdmin;
  String get id => _id;
  set name(String value)=>_name = value;
  set isAdmin(bool value)=>_isAdmin = value;

}