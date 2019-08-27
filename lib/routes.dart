import 'package:flutter/material.dart';

import './pages/export_pages.dart';

abstract class Routes {
    /// <h2>Route: /new-bus </h2>
    static const String NEW_BUS_PAGE = '/new-bus';

    /// <h2>Roue: /new-category </h2>
    static const String NEW_CATEGORY_PAGE = '/new-category';

    /// <h2>Roue: /new-account </h2>
    static const String NEW_ACCOUNT_PAGE = '/new-account';

    /// <h2>Route: /auth-page </h2>
    static const String MAIN_AUTH_PAGE = '/auth-page';

    static final Map<String, WidgetBuilder> _availableRoutes = {
        NEW_BUS_PAGE: (BuildContext ctx) => NewBusPage(),
        NEW_CATEGORY_PAGE: (BuildContext ctx) => NewCategoryPage(),
        MAIN_AUTH_PAGE: (BuildContext ctx) => MainAuthPage(),
    };

    static Map<String, WidgetBuilder> get availableRoutes => Map.from(_availableRoutes);

}
