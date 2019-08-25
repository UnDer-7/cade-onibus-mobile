import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/dio_config.dart';
import '../utils/api_util.dart';
import '../models/user.dart';
import '../models/category.dart';

abstract class UserResource {
    static final Dio _dioAuth = DioConfig.dioFactory();
    static final Dio _dio = Dio();
    static final String _resourceUrl = '${APIUtil.api}/users';

    static Future<User> getUser(String email) async {
        print('GET request to get user \tURL: $_resourceUrl/$email');
        return _dioAuth.get(_resourceUrl + '/$email')
            .then((res) => res.data)
            .then((user) => User.fromJSON(user));
    }

    static Future<User> createUserWithGoogle(final GoogleSignInAccount google) async {
        print('POST request create user with Google\tURL: $_resourceUrl');
        final Map<String, String> user = {
            'email': google.email,
            'google_id': google.id,
            'name': google.displayName,
        };

        return _dio.post(_resourceUrl, data: json.encode(user))
            .then((res) => res.data)
            .then((user) => User.fromJSON(user));
    }

    static Future<User> createUserWithEmail(final String email, final String password) async {
        print('POST request create user with Email\tURL: $_resourceUrl');
        final Map<String, String> user = {
            'email': email,
            'password': password,
        };

        return _dio.post(_resourceUrl, data: json.encode(user))
            .then((res) => res.data)
            .then((user) => User.fromJSON(user));
    }

    static Future<List<Category>> addCategory(String category) {
        print('POST request to add new category\tURL: $_resourceUrl/category');
        return _dioAuth.post(_resourceUrl + '/category', data: category)
            .then((res) => res.data)
            .then((categories) => categories.map((cat) => Category.fromJSON(cat)).toList())
            .then((untyped) => List<Category>.from(untyped));
    }

    static Future<List<Category>> updateCategory(String category) {
        print('PUT request to update category\tURL: $_resourceUrl/category');
        return _dioAuth.put(_resourceUrl + '/category', data: category)
            .then((res) => res.data)
            .then((categories) => categories.map((cat) => Category.fromJSON(cat)).toList())
            .then((untyped) => List<Category>.from(untyped));
    }

    static Future<List<Category>> deleteCategory(String category, String uuid) {
        print('DELETE request to delete category\tURL: $_resourceUrl/category/$uuid');
        return _dioAuth.delete(_resourceUrl + '/category/$uuid', data: category)
            .then((res) => res.data)
            .then((categories) => categories.map((cat) => Category.fromJSON(cat)).toList())
            .then((untyped) => List<Category>.from(untyped));
    }

    static Future<List<Category>> removeBus(String bus, String id) {
        print('DELETE request to remove bus\tURL: $_resourceUrl/category/bus/$id');
        return _dioAuth.delete(_resourceUrl + '/category/bus/$id', data: bus)
            .then((res) => res.data)
            .then((categories) => categories.map((cat) => Category.fromJSON(cat)).toList())
            .then((untyped) => List<Category>.from(untyped));
    }
}
