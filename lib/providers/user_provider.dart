import 'package:flutter/material.dart';
import 'dart:convert';

import '../resources/users_resource.dart';
import '../models/category.dart';
import '../models/user.dart';

class UserProviders with ChangeNotifier {
    User _user;

    Future<void> addCategory(Category category) async {
        final jsonBody = Category.toJSON(category);

        _user.categories = await UserResource.addCategory(json.encode(jsonBody));
        notifyListeners();
    }

    List<Category> get getCategory => List.unmodifiable(_user.categories);

    static Future<User> findUser(String email) async {
        return await UserResource.getUser(email);
    }

    void setCurrentUser(User user) => _user = user;
}
