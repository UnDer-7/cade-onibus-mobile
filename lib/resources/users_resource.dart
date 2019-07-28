import 'package:dio/dio.dart';

import '../models/user.dart';
import '../models/category.dart';

abstract class UserResource {
    static final Dio _dio = Dio();
    static final String _resourceUrl = 'http://localhost:8080/api/users';

    static Future<User> getUser(String email) {
        return _dio.get(_resourceUrl + '/$email')
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
}
