import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './routes.dart';

import './utils/custom_colors.dart';

import './pages/home_page.dart';

import './providers/categories_provider.dart';
void main() => runApp(CadeVan());

class CadeVan extends StatelessWidget {
    @override
    MultiProvider build(BuildContext context) {
        return MultiProvider(
            providers: [
                ChangeNotifierProvider.value(
                    value: CategoriesProviders(),
                )
            ],
            child: MaterialApp(
                title: 'Cadê Ônibus',
                theme: ThemeData(
                    primarySwatch: CustomColors.primaryColor,
                    accentColor: CustomColors.primaryColor,
                ),
                home: HomePage(),
                routes: Routes.availableRoutes,
            ),
        );
    }
}
