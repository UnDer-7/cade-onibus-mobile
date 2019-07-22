import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/bus_coordinates.dart';
import '../models/coordinates.dart';

class MapPage extends StatefulWidget {
    final List<BusCoordinates> _busesCoordinates;
    final Coordinates _coordinates;

    MapPage(this._coordinates, [this._busesCoordinates]);

    @override
    _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
    BitmapDescriptor _busIcon;

    @override
    Widget build(BuildContext context) {
        _createMarkerImageFromAsset(context);
        return Scaffold(
            body: Stack(
                children: <Widget>[
                    GoogleMap(
                        markers: _busMarkers,
                        initialCameraPosition: CameraPosition(
                            zoom: 15,
                            target: LatLng(widget._coordinates.latitude, widget._coordinates.longitude),
                        ),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 60),
                        padding: EdgeInsets.all(5),
                        child: Text(
                            'Seu onibus atual: ${widget._busesCoordinates[0].properties.linha}',
                            style: TextStyle(
                                color: Colors.white,
                            ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).primaryColor,
                        ),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () {},
                                    child: Text(
                                        'PROCURAR OUTRO ÔNIBUS',
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                    ),
                                ),
                            ),
                        ],
                    ),
                ],
            ),
        );
    }

    Set<Marker> get _busMarkers {
        Set<Marker> markers = {
            Marker(
                infoWindow: InfoWindow(
                    title: 'Minha Posição'
                ),
                markerId: MarkerId('user-marker'),
                position: LatLng(widget._coordinates.latitude, widget._coordinates.longitude),
            ),
        };

        widget._busesCoordinates.forEach((bus) => markers.add(
            Marker(
                icon: _busIcon,
                infoWindow: InfoWindow(
                    title: 'Linha: ${bus.properties.linha}',
                ),
                markerId: MarkerId(bus.properties.numero),
                position: LatLng(bus.coordinates.latitude, bus.coordinates.longitude),
            ),
        ));

        return markers;
    }

    Future<void> _createMarkerImageFromAsset(BuildContext context) async {
        final ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context);
        BitmapDescriptor.fromAssetImage(
            imageConfiguration,
            'assets/images/bus-icon-128.png',
        ).then(_updateBitmap);
    }

    void _updateBitmap(BitmapDescriptor bitmap) {
        setState(() {
            _busIcon = bitmap;
        });
    }
}
