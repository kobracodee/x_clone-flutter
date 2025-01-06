// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import 'package:x_clone/models/crud.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/utilities/constants.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _userModel;
  bool _isLoading = false;
  Crud _crud = Crud();

  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;

  Future<String> post(String url, String content) async {
    var response = await _crud.postRequest(
      url,
      {
        Constants.USER_ID: _userModel!.id,
        Constants.CONTENT: content,
      },
    );

    if (response[Constants.SUCCESS] == "true") {
      return response[Constants.MESSAGE].toString();
    } else {
      return response[Constants.MESSAGE].toString();
    }
  }

  void setBio(String bio) {
    setUser(_userModel!.copyWith(bio: bio));
  }

  void setUser(UserModel newUser) {
    _userModel = newUser;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearUser() {
    _userModel = null;
    notifyListeners();
  }
}
