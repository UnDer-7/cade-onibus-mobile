import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../routes.dart';

import '../providers/categories_provider.dart';

import '../widgets/bus_category.dart';

class HomePage extends StatelessWidget {

    @override
    Scaffold build(BuildContext context) =>
        Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text('Cadê Ônibus'),
            ),
            floatingActionButton: SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                children: [
                    SpeedDialChild(
                        onTap: () => Navigator.pushNamed(context, Routes.NEW_BUS_PAGE),
                        child: Icon(Icons.directions_bus),
                        label: 'Novo Ônibus'
                    ),
                    SpeedDialChild(
                        onTap: () => Navigator.pushNamed(context, Routes.NEW_CATEGORY_PAGE),
                        child: Icon(Icons.category),
                        label: 'Nova Categoria'
                    ),
                ],
            ),
            body: Consumer<CategoriesProviders>(
                builder: (_, CategoriesProviders model, Widget widget) =>
                    ListView.builder(
                        itemCount: model.getCategory.length,
                        itemBuilder: (BuildContext ctx, int i) => BusCategory(model.getCategory[i]),
                    ),
            ),
        );
}
