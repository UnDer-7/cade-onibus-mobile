import 'package:cade_onibus_mobile/models/bus.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../models/category.dart';
import '../models/user.dart';

import '../resources/category_resource.dart';
import '../resources/users_resource.dart';

class UserProviders with ChangeNotifier {
    User _user;

    Future<void> addCategory(Category category) async {
        final jsonBody = Category.toJSON(category);

        _user.categories = await CategoryResource.addCategory(json.encode(jsonBody));
        notifyListeners();
    }

    Future<void> updateCategory(Category category) async {
        final jsonBody = Category.toJSON(category);

        _user.categories = await CategoryResource.updateCategory(json.encode(jsonBody));
        notifyListeners();
    }

    Future<void> deleteCategory(Category category) async {
        final jsonBody = Category.toJSON(category);
        _user.categories = await CategoryResource.deleteCategory(json.encode(jsonBody), category.uuid);
        notifyListeners();
    }

    Future<void> deleteBus(Bus bus, String id) async {
        final jsonBody = Bus.toJSON(bus);
        _user.categories = await CategoryResource.removeBus(json.encode(jsonBody), id);
        notifyListeners();
    }

    List<Category> get getCategory => List.unmodifiable(_user.categories);

    static Future<User> findUser(String email) async {
        return await UserResource.getUser(email);
    }

    void setCurrentUser(User user) => _user = user;
}
