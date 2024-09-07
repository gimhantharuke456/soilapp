import 'package:flutter/material.dart';
import 'package:soilapp/models/user.model.dart';
import 'package:soilapp/providers/user.provider.dart';
import 'package:soilapp/services/app.user.service.dart';

class SetProfileViewModel extends ChangeNotifier {
  final UserProvider provider;

  SetProfileViewModel({required this.provider});

  final UserService _userService = UserService();
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> loadCurrentUser() async {
    _isLoading = true;
    notifyListeners();

    _currentUser = await _userService.getCurrentUser();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveProfile(String name, String email, String description,
      String phoneNumber, String city) async {
    _isLoading = true;
    notifyListeners();

    final updatedUser = UserModel(
      id: _currentUser?.id,
      name: name,
      email: email,
      description: description,
      phoneNumber: phoneNumber,
      city: city,
    );

    if (_currentUser == null) {
      await _userService.createUser(updatedUser);
    } else {
      await _userService.updateUser(updatedUser);
    }

    _currentUser = updatedUser;
    if (_currentUser != null) {
      provider.setCurrentUser = _currentUser!;
    }

    _isLoading = false;
    notifyListeners();
  }
}
