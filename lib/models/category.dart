import 'package:flutter/material.dart';

import './bus.dart';

class Category {
    String id;
    String title;
    int cardColor;
    List<Bus> buses;

    Category({
        this.id,
        @required this.title,
        @required this.cardColor,
        @required this.buses
    });

    Category.fromJSON(dynamic json) :
        id = json['_id'],
        title = json['title'],
        cardColor = json['cardColor'],
        buses = _setBusesFromJSON(json['buses']);

    static Map<String, dynamic> toJSON(Category category) =>
        {
            '_id': category.id,
            'title': category.title,
            'cardColor': category.cardColor,
            'buses': _setBusesToJSON(category.buses),
        };

    @override
    String toString() {
        StringBuffer buffer = StringBuffer();
        buffer.writeln('Category: {');
        buffer.writeln('ID: $id');
        buffer.writeln('Title: $title');
        buffer.writeln('CardColor: $cardColor');
        buffer.write('Buses: ');
        buses.forEach((f) => buffer.writeln(f.toString()));
        buffer.write('}');
        return buffer.toString();
    }

    static List<Bus> _setBusesFromJSON(dynamic json) =>
        List<Bus>.from(json.map((item) => Bus.fromJSON(item)).toList());

    static List<Map<String, dynamic>> _setBusesToJSON(List<Bus> buses) =>
        buses.map((item) => Bus.toJSON(item)).toList();
}
