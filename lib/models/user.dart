import 'package:flutter/material.dart';

class User{
  String _id;
  String _name = "undefined";
  bool _isAdmin = false;
  bool _isTelevision = false;

  User(this._id);
  String get name => _name;
  bool get isAdmin => _isAdmin;
  String get id => _id;
  set name(String value)=>_name = value;
  set isAdmin(bool value)=>_isAdmin = value;

}