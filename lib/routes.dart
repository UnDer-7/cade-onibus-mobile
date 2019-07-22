import 'package:flutter/material.dart';

import './pages/export_pages.dart';

abstract class Routes {
    /// <h2>Route: /new-bus </h2>
    static const String NEW_BUS_PAGE = '/new-bus';

    /// <h2>Roue: /new-category </h2>
    static const String NEW_CATEGORY_PAGE = '/new-category';

    static final Map<String, WidgetBuilder> _availableRoutes = {
        NEW_BUS_PAGE: (BuildContext ctx) => NewBusPage(),
        NEW_CATEGORY_PAGE: (BuildContext ctx) => NewCategoryPage(),
    };

    static Map<String, WidgetBuilder> get availableRoutes => Map.from(_availableRoutes);

}
