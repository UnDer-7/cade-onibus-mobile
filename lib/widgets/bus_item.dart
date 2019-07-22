import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../services/location_service.dart';
import '../pages/map_page.dart';
import '../resources/df_trans_resource.dart';
import '../models/bus.dart';
import '../models/coordinates.dart';

class BusItem extends StatefulWidget {
    final Bus bus;

    BusItem(this.bus);

    @override
    _BusItemState createState() => _BusItemState();
}

class _BusItemState extends State<BusItem> {
    bool _isLoading = false;

    @override
    Widget build(BuildContext context) =>
        Column(
            children: <Widget>[
                if (_isLoading) Center(
                    child: CircularProgressIndicator(),
                ),
                if (!_isLoading) ListTile(
                    onTap: () => _handleOnTap(context),
                    onLongPress: () => print('long'),
                    leading: Chip(
                        label: Text(
                            widget.bus.numero,
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                            ),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                        widget.bus.descricao,
                        textAlign: TextAlign.center,
                    ),
                    trailing: Text(
                        'R\$ ${widget.bus.faixaTarifaria.tarifa.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Colors.red
                        ),
                    ),
                ),
                if (!_isLoading) Divider(
                    color: Colors.black87,
                    indent: 10,
                    endIndent: 10,
                ),
            ],
        );

    _handleOnTap(BuildContext context) async {
        setState(() => _isLoading = true);
        try {
            final location = await DFTransResource.findBusLocation(
                widget.bus.numero);
            final locationService = await LocationService.userLocation;

            final Coordinates userLocation = Coordinates(
                latitude: locationService.latitude,
                longitude: locationService.longitude,
            );

            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) =>
                    MapPage(userLocation, location),
            )).whenComplete(() => _isLoading = false);
        } catch(e)  {
            print('Error -> $e');
            _isLoading = false;
        }
    }
}
