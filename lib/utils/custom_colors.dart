import 'package:flutter/material.dart';

abstract class CustomColors {
    static Color getTextColor(Color color) {
        int d = 0;
        double luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

        if (luminance > 0.5) {
            d = 0;
        } else {
            d = 255;
        }
        return Color.fromARGB(color.alpha, d, d, d);
    }
}
