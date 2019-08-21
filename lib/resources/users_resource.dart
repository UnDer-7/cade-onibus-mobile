import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils/api_util.dart';
import '../models/user.dart';
import '../models/category.dart';

abstract class UserResource {
    static final Dio _dio = Dio();
    static final String _resourceUrl = '${APIUtil.api}/users';

    static Future<User> getUser(String email) {
        return _dio.get(_resourceUrl + '/$email')
            .then((res) => res.data)
            .then((user) => User.fromJSON(user));
    }

    static Future<User> createUserWithGoogle(final GoogleSignInAccount google) async {
        final Map<String, String> user = {
            'email': google.email,
            'google_id': google.id,
            'name': google.displayName,
        };

        return _dio.post(_resourceUrl, data: json.encode(user))
            .then((res) => res.data)
            .then((user) => User.fromJSON(user));
    }

    static Future<User> createUserWithEmail(final String email, final String password, final String name) async {
        final Map<String, String> user = {
            'name': name,
            'email': email,
            'password': password,
        };

        return _dio.post(_resourceUrl, data: json.encode(user))
            .then((res) => res.data)
            .then((user) => User.fromJSON(user));
    }

    static Future<List<Category>> addCategory(String category) {
        return _dio.post(_resourceUrl + '/category', data: category)
            .then((res) => res.data)
            .then((categories) => categories.map((cat) => Category.fromJSON(cat)).toList())
            .then((untyped) => List<Category>.from(untyped));
    }

    static Future<List<Category>> updateCategory(String category) {
        return _dio.put(_resourceUrl + '/category', data: category)
            .then((res) => res.data)
            .then((categories) => categories.map((cat) => Category.fromJSON(cat)).toList())
            .then((untyped) => List<Category>.from(untyped));
    }

    static Future<List<Category>> deleteCategory(String category, String uuid) {
        return _dio.delete(_resourceUrl + '/category/$uuid', data: category)
            .then((res) => res.data)
            .then((categories) => categories.map((cat) => Category.fromJSON(cat)).toList())
            .then((untyped) => List<Category>.from(untyped));
    }

    static Future<List<Category>> removeBus(String bus, String id) {
        return _dio.delete(_resourceUrl + '/category/bus/$id', data: bus)
            .then((res) => res.data)
            .then((categories) => categories.map((cat) => Category.fromJSON(cat)).toList())
            .then((untyped) => List<Category>.from(untyped));
    }
}
