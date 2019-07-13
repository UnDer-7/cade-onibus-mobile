import 'package:flutter/material.dart';

import './bus_tab.dart';

class MainTabs extends StatelessWidget {
    @override
    DefaultTabController build(BuildContext context) =>
        DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text('Cadê Ônibus'),
                ),
                body: TabBarView(
                    children: <Widget>[
                        BusTab(),
                        Container(color: Colors.blue),
                    ],
                ),
                bottomNavigationBar: TabBar(
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: <Widget>[
                        Tab(
                            icon: IconTheme(
                                data: IconThemeData(color: Theme.of(context).primaryColor),
                                child: Icon(Icons.directions_bus),
                            ),
                        ),
                        Tab(
                            icon: IconTheme(
                                data: IconThemeData(color: Theme.of(context).primaryColor),
                                child: Icon(Icons.map),
                            ),
                        ),
                    ],
                ),
            ),
        );
}
