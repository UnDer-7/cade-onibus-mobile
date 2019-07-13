import 'package:flutter/material.dart';

class BusItem extends StatelessWidget {
    @override
    Widget build(BuildContext context) =>
        Column(
            children: <Widget>[
                ListTile(
                    onTap: () => print('tap'),
                    onLongPress: () => print('long'),
                    leading: Chip(
                        label: Text(
                            '501.4',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                            ),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                        'Samambaia Norte (1 Avenida)/ Rodoviária do Plano Piloto (SHIS - EPNB - EIXO)',
                        textAlign: TextAlign.center,
                    ),
                    trailing: Text(
                        'R\$ 5,00',
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
