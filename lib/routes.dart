import 'package:flutter/material.dart';

import './pages/new_account_page.dart';
import './pages/export_pages.dart';

abstract class Routes {
    /// <h2>Route: /new-bus </h2>
    static const String NEW_BUS_PAGE = '/new-bus';

    /// <h2>Roue: /new-category </h2>
    static const String NEW_CATEGORY_PAGE = '/new-category';

    /// <h2>Roue: /new-account </h2>
    static const String NEW_ACCOUNT_PAGE = '/new-account';

    static final Map<String, WidgetBuilder> _availableRoutes = {
        NEW_BUS_PAGE: (BuildContext ctx) => NewBusPage(),
        NEW_CATEGORY_PAGE: (BuildContext ctx) => NewCategoryPage(),
        NEW_ACCOUNT_PAGE: (BuildContext ctx) => NewAccountPage(),
    };

    static Map<String, WidgetBuilder> get availableRoutes => Map.from(_availableRoutes);

}
