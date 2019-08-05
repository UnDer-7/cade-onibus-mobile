import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/bus.dart';
import '../models/bus_coordinates.dart';
import '../models/coordinates.dart';
import '../resources/df_trans_resource.dart';
import '../utils/toast_util.dart';

class MapPage extends StatefulWidget {
    final Coordinates _userCoordinates;
    final List<Bus> busesToTrack;

    MapPage(
        this._userCoordinates,
        {
            this.busesToTrack,
        });

    @override
    _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
    final Map<String, List<BusCoordinates>> _dfTransBuses = {};
    final List<String> _deletedLines = [];
    bool _isLoading = true;
    bool _cancelTimer = false;
    BitmapDescriptor _busIcon;
    Set<Marker> _markers;
    String _linhaSelected;

    @override
    void initState() {
        Timer.periodic(Duration(seconds: 5), (timer) async {
            if (_cancelTimer) return timer.cancel();

            widget.busesToTrack.forEach((item) async {
                _isLoading = true;
                try {
                    final busFound = await DFTransResource.findBusLocation(item.numero);
                    if (_deletedLines.contains(item.numero)) return;
                    _dfTransBuses[item.numero] = busFound;
                    _addBusMarker();
                } on DioError catch(e) {
                    ToastUtil.showToast('Algo deu errado', context, color: ToastUtil.error);
                    print('ERRO NO MAPS_PAGE\n$e');
                } finally {
                    _isLoading = false;
                }
            });
        });

        super.initState();
    }

    @override
    void dispose() {
        _cancelTimer = true;
        super.dispose();
    }

    @override
    void deactivate() {
        _cancelTimer = true;
        super.deactivate();
    }

    @override
    WillPopScope build(BuildContext context) {
        _createMarkerImageFromAsset(context);
        final List<String> _buses = widget.busesToTrack.map((f) => f.numero).toList();

        return WillPopScope(
            onWillPop: () {
                _cancelTimer = true;
                return Future.value(true);
            },
            child: Scaffold(
                body: Stack(
                    children: <Widget>[
                        GoogleMap(
                            markers: _markers,
                            initialCameraPosition: CameraPosition(
                                zoom: 15,
                                target: LatLng(widget._userCoordinates.latitude, widget._userCoordinates.longitude),
                            ),
                        ),
                        Container(
                            height: 140,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 40),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _buses.length,
                                itemBuilder: (BuildContext ctx, int i) =>
                                    Column(
                                        children: <Widget>[
                                            Container(
                                                margin: EdgeInsets.symmetric(horizontal: 10),
                                                height: 40,
                                                width: 70,
                                                child: RaisedButton(
                                                    onPressed: () {
                                                        if (_linhaSelected == _buses[i]){
                                                            _linhaSelected = null;
                                                            return;
                                                        }
                                                        _linhaSelected = _buses[i];
                                                    },
                                                    elevation: 0,
                                                    padding: EdgeInsets.symmetric(horizontal: 0),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                    color: getBusBadgeColor(_buses[i], context),
                                                    child: getBadgeContent(_buses[i]),
                                                ),
                                            ),
                                            if (_linhaSelected == _buses[i]) Card(
                                                color: getBusBadgeColor(_buses[i], context),
                                                child: Column(
                                                    children: <Widget>[
                                                        Container(
                                                            margin: EdgeInsets.all(10),
                                                            child: Text(
                                                                getCardText(_buses[i]),
                                                                style: TextStyle(color: Colors.white),
                                                            ),
                                                        ),
                                                        RaisedButton(
                                                            onPressed: () => _removeBusFromTracking(_buses[i]),
                                                            elevation: 10,
                                                            color: Colors.white,
                                                            child: Text('Parar de rastrear'),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                        ],
                                    ),
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
            ),
        );
    }

    String getCardText(String linha) {
        if (_dfTransBuses[linha].isEmpty) return 'Nenhum ônibus encontrado';
        return 'Ônibus encontrados: ${_dfTransBuses[linha].length}';
    }

    Widget getBadgeContent(String linha) {
        if (_isLoading) {
            return Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
            );
        }
        return Text(
            linha,
            style: TextStyle(
                color: Colors.white,
            ),
        );
    }

    Color getBusBadgeColor(String linha, BuildContext context) {
        if (_dfTransBuses[linha] == null) return Theme.of(context).primaryColor;

        final bool isEmpty = _dfTransBuses[linha].isEmpty;

        if (isEmpty) return Colors.orangeAccent;
        return Colors.green;
    }

    void _addBusMarker() {
        _markers = {
            Marker(
                infoWindow: InfoWindow(
                    title: 'Minha Posição'
                ),
                markerId: MarkerId('user-marker'),
                position: LatLng(widget._userCoordinates.latitude, widget._userCoordinates.longitude),
            ),
        };

        _dfTransBuses.forEach((key, busList) => busList.forEach((bus) => setState(() => _markers.add(
            Marker(
                markerId: MarkerId(bus.properties.numero + bus.properties.linha),
                position: LatLng(bus.coordinates.latitude, bus.coordinates.longitude),
                icon: _busIcon,
                infoWindow: InfoWindow(
                    title: 'Linha: ${bus.properties.linha}',
                )
            ),
        ))));
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

    void _removeBusFromTracking(String linha) {
        widget.busesToTrack.removeWhere((bus) => bus.numero == linha);
        _dfTransBuses.remove(linha);
        _markers.removeWhere((item) => item.markerId.value.contains(linha));
        _deletedLines.add(linha);
    }
}
