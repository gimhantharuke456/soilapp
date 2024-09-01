import 'package:flutter/material.dart';
import 'package:soilapp/models/user.model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;

  set setCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  UserModel? get currentUser => _currentUser;
}
