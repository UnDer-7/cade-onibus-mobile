import 'package:flutter/material.dart';

import './bus.dart';

class Category {
    String title;
    Color cardColor;
    List<Bus> buses;

    Category({
        @required this.title,
        @required this.cardColor,
        @required this.buses
    });

    @override
    String toString() {
        StringBuffer buffer = StringBuffer();
        buffer.writeln('Category: {');
        buffer.writeln('Title: $title');
        buffer.writeln('CardColor: $cardColor');
        buffer.write('Buses: ');
        buses.forEach((f) => buffer.writeln(f.toString()));
        buffer.write('}');
        return buffer.toString();
    }
}
