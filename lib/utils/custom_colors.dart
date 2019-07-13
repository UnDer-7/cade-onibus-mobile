import 'package:flutter/material.dart';

abstract class CustomColors {
    static final int _red = 112;
    static final int _green = 68;
    static final int _blue = 255;

    static final Map<int, Color> _appColor = {
        50: Color.fromRGBO(_red, _green, _blue, .1),
        100: Color.fromRGBO(_red, _green, _blue, .2),
        200: Color.fromRGBO(_red, _green, _blue, .3),
        300: Color.fromRGBO(_red, _green, _blue, .4),
        400: Color.fromRGBO(_red, _green, _blue, .5),
        500: Color.fromRGBO(_red, _green, _blue, .6),
        600: Color.fromRGBO(_red, _green, _blue, .7),
        700: Color.fromRGBO(_red, _green, _blue, .8),
        800: Color.fromRGBO(_red, _green, _blue, .9),
        900: Color.fromRGBO(_red, _green, _blue, 1),
    };

    static Color switchColor(Color color) {
        int d = 0;
        double luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

        if (luminance > 0.5) {
            d = 0;
        } else {
            d = 255;
        }
        return Color.fromARGB(color.alpha, d, d, d);
    }

    static MaterialColor get primaryColor => MaterialColor(0xFF7044ff, _appColor);
}
