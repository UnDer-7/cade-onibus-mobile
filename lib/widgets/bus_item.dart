import 'package:flutter/material.dart';

import '../models/bus.dart';

class BusItem extends StatelessWidget {
    final Bus bus;

    BusItem(this.bus);

    @override
    Widget build(BuildContext context) =>
        Column(
            children: <Widget>[
                ListTile(
                    onTap: () => print('tap'),
                    onLongPress: () => print('long'),
                    leading: Chip(
                        label: Text(
                            bus.numero,
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                            ),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                        bus.descricao,
                        textAlign: TextAlign.center,
                    ),
                    trailing: Text(
                        'R\$ ${bus.faixaTarifaria.tarifa.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Colors.red
                        ),
                    ),
                ),
                Divider(
                    color: Colors.black87,
                    indent: 10,
                    endIndent: 10,
                ),
            ],
        );
}
