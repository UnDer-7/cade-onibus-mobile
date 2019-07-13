import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../widgets/bus_category.dart';

class BusTab extends StatelessWidget {
    @override
    Scaffold build(BuildContext context) =>
        Scaffold(
            floatingActionButton: SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                children: [
                    SpeedDialChild(
                        onTap: () => print('Novo Ônibus'),
                        child: Icon(Icons.directions_bus),
                        label: 'Novo Ônibus'
                    ),
                    SpeedDialChild(
                        onTap: () => print('Nova Categoria'),
                        child: Icon(Icons.category),
                        label: 'Nova Categoria'
                    ),
                ],
            ),
            body: ListView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext ctx, int i) => BusCategory(),
            ),
        );
}
