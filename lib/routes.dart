import 'package:flutter/material.dart';

import './screens/new_bus_screen.dart';

abstract class Routes {
    /// <h2>Route: /new-bus </h2>
    static const String newBusScreen = '/new-bus';

    static final Map<String, WidgetBuilder> _availableRoutes = {
      newBusScreen: (BuildContext ctx) => NewBusScreen(),
    };

    static Map<String, WidgetBuilder> get availableRoutes => Map.from(_availableRoutes);

}
