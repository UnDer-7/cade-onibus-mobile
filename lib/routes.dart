import 'package:flutter/material.dart';

import './screens/new_bus_screen.dart';
import './screens/new_category.dart';

abstract class Routes {
    /// <h2>Route: /new-bus </h2>
    static const String NEW_BUS_SCREEN = '/new-bus';

    /// <h2>Roue: /new-category </h2>
    static const String NEW_CATEGORY_SCREEN = '/new-category';

    static final Map<String, WidgetBuilder> _availableRoutes = {
        NEW_BUS_SCREEN: (BuildContext ctx) => NewBusScreen(),
        NEW_CATEGORY_SCREEN: (BuildContext ctx) => NewCategory(),
    };

    static Map<String, WidgetBuilder> get availableRoutes => Map.from(_availableRoutes);

}
