import 'package:flutter/material.dart';

import './routes.dart';

import './utils/custom_colors.dart';

import './pages/home_page.dart';

void main() => runApp(CadeVan());

class CadeVan extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Cadê Ônibus',
            theme: ThemeData(
                primarySwatch: CustomColors.primaryColor,
                accentColor: CustomColors.primaryColor,
            ),
            home: HomePage(),
            routes: Routes.availableRoutes,
        );
    }
}
