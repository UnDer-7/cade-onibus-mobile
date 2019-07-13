import 'package:flutter/material.dart';

import '../widgets/bus_item.dart';

class NewBusScreen extends StatelessWidget {
    @override
    Scaffold build(BuildContext context) {
        final double height = MediaQuery.of(context).size.height;

        return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text('Novo Ônibus'),
            ),
            body: SingleChildScrollView(
              child: Column(
                  children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextField(
                              autofocus: true,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.search),
                                  labelText: 'DIGITE UMA LINHA OU CIDADE',
                              ),
                          ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          height: height,
                          child: ListView.builder(
                              itemCount: 20,
                              itemBuilder: (BuildContext ctx, int i) => BusItem(),
                          ),
                      )
                  ],
              ),
            ),
        );
    }
}
