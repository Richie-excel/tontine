import 'package:flutter/material.dart';
import 'package:tontine/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user; // Store user object

  UserModel? get user => _user; // Getter for user

  void setUser(UserModel newUser) {
    _user = newUser;
    notifyListeners(); // Notify UI of changes
  }
}

