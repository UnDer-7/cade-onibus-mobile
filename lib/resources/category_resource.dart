import 'package:dio/dio.dart';

import '../config/dio_config.dart';
import '../environments/environment.dart';
import '../models/category.dart';

abstract class CategoryResource {
    static final Dio _dioAuth = DioConfig.dioFactory();
    static final String _resourceUrl = '${Environment.api}/categories';

    static Future<List<Category>> addCategory(String category) {
        print('POST request to add new category\tURL: $_resourceUrl');
        return _dioAuth.post(_resourceUrl, data: category)
            .then((res) => res.data)
            .then((categories) => categories.map((cat) => Category.fromJSON(cat)).toList())
            .then((untyped) => List<Category>.from(untyped));
    }

    static Future<List<Category>> updateCategory(String category) {
        print('PUT request to update category\tURL: $_resourceUrl');
        return _dioAuth.put(_resourceUrl, data: category)
            .then((res) => res.data)
            .then((categories) => categories.map((cat) => Category.fromJSON(cat)).toList())
            .then((untyped) => List<Category>.from(untyped));
    }

    static Future<List<Category>> removeBus(String bus, String id) {
        print('DELETE request to remove bus\tURL: $_resourceUrl/bus/$id');
        return _dioAuth.delete(_resourceUrl + '/bus/$id', data: bus)
            .then((res) => res.data)
            .then((categories) => categories.map((cat) => Category.fromJSON(cat)).toList())
            .then((untyped) => List<Category>.from(untyped));
    }

    static Future<List<Category>> deleteCategory(String category, String uuid) {
        print('DELETE request to delete category\tURL: $_resourceUrl - Params: $uuid');
        return _dioAuth.delete(_resourceUrl, data: category, queryParameters: { 'uuid': uuid } )
            .then((res) => res.data)
            .then((categories) => categories.map((cat) => Category.fromJSON(cat)).toList())
            .then((untyped) => List<Category>.from(untyped));
    }
}
