import 'package:flutter/material.dart';

import '../services/location_service.dart';
import '../pages/map_page.dart';
import '../resources/df_trans_resource.dart';
import '../models/bus.dart';
import '../models/coordinates.dart';

class BusItem extends StatelessWidget {
    final Bus bus;

    BusItem(this.bus);

    @override
    Widget build(BuildContext context) =>
        Column(
            children: <Widget>[
                ListTile(
                    onTap: () => _handleOnTap(context),
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

    _handleOnTap(BuildContext context) async {
        final location = await DFTransResource.findBusLocation(bus.numero);
        final locationService = await LocationService.userLocation;

        final Coordinates userLocation = Coordinates(
            latitude: locationService.latitude,
            longitude: locationService.longitude,
        );

        Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => MapPage(userLocation, location),
        ));
    }
}
