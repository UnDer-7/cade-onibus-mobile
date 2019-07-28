import 'package:meta/meta.dart';

import './category.dart';

class User {
    String id;
    String name;
    String email;
    String googleId;
    String createdAt;
    List<Category> categories = [];

    User({
        @required this.id,
        @required this.name,
        @required this.email,
        @required this.googleId,
        @required this.createdAt,
        this.categories,
    });

    User.fromJSON(dynamic json) :
            id = json['_id'],
            name = json['name'],
            email = json['email'],
            googleId = json['google_id'],
            createdAt = json['createdAt'],
            categories = _setCategoriesFromJSON(json['categories']);

    static Map<String, dynamic> toJSON(User user) =>
        {
            '_id': user.id,
            'name': user.name,
            'email': user.email,
            'google_id': user.googleId,
            'createdAt': user.createdAt,
            'categories': _setCategoriesToJSON(user.categories),
        };

    @override
    String toString() {
        StringBuffer buffer = StringBuffer();
        buffer.writeln('User: {');
        buffer.writeln('Id: $id');
        buffer.writeln('Name: $name');
        buffer.writeln('GoogleId: $googleId');
        buffer.writeln('CreatedAt: $createdAt');
        buffer.write('categories: ');
        categories.forEach((f) => buffer.writeln(f.toString()));
        buffer.writeln('}');
        return buffer.toString();
    }

    static List<Category> _setCategoriesFromJSON(dynamic json) =>
        List<Category>
            .from(json.map((item) => Category.fromJSON(item)).toList());

    static List<Map<String, dynamic>> _setCategoriesToJSON(List<Category> categories) =>
        categories.map((item) => Category.toJSON(item)).toList();
}
