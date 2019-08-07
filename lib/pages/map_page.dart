import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../models/bus.dart';
import '../models/bus_coordinates.dart';

import '../providers/bus_selected.dart';
import '../pages/new_bus_page.dart';
import '../resources/df_trans_resource.dart';
import '../utils/toast_util.dart';

class MapPage extends StatefulWidget {
    final List<Bus> busesToTrack;

    MapPage({ this.busesToTrack });

    @override
    _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
    final Map<String, List<BusCoordinates>> _dfTransBuses = {};
    final List<String> _deletedLines = [];
    StreamSubscription<LocationData> _locationStream;
    Location _location = Location();
    LatLng _latLng;
    List<Bus> _busToTrackState = [];
    bool _isLoading = true;
    bool _cancelTimer = false;
    BitmapDescriptor _busIcon;
    Set<Marker> _markers;
    String _linhaSelected;

    @override
    void initState() {
        _locationStream = _location
            .onLocationChanged()
            .listen((data) => _watchUserLocation(data));

        _busToTrackState = widget.busesToTrack;

        Timer.periodic(Duration(seconds: 10), (timer) async {
            _watchBusLocation(timer);
        });

        super.initState();
    }

    @override
    Future deactivate() async {
        await _locationStream.cancel();
        super.deactivate();
    }

    @override
    WillPopScope build(BuildContext context) {
        _createMarkerImageFromAsset(context);
        final BusSelected _busSelected = Provider.of<BusSelected>(context);
        final List<String> _buses = _busToTrackState.map((f) => f.numero).toList();

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
                                target: _latLng,
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
                        Padding(
                            padding: EdgeInsets.only(bottom: 50),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                    IconButton(
                                        onPressed: () => print('TODO info button'),
                                        icon: Icon(
                                            Icons.info,
                                            color: Theme.of(context).primaryColor,
                                            size: 45,
                                        ),
                                    ),
                                    if (!_isLoading)IconButton(
                                        onPressed: _watchBusLocation,
                                        icon: Icon(
                                            Icons.refresh,
                                            color: Theme.of(context).primaryColor,
                                            size: 50,
                                        ),
                                    ),
                                    if (_isLoading) Padding(
                                        padding: EdgeInsets.only(left: 10, top: 12),
                                        child: CircularProgressIndicator(),
                                    ),
                                ],
                            ),
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                                RaisedButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () =>
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (BuildContext ctx) => NewBusPage(isMultiSelection: true, isForSaving: false),
                                        )).then((res) {
                                            if (res == null || res == false) {
                                                _busSelected.cleanBusSelected();
                                                return;
                                            }
                                            _busSelected.getAllBusSelected.forEach((bus) => setState(() => _busToTrackState.add(bus)));
                                            _watchBusLocation();
                                            _busSelected.cleanBusSelected();
                                        }),
                                    child: Text(
                                        'PROCURAR OUTRO ÔNIBUS',
                                        style: TextStyle(
                                            color: Colors.white
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
                position: _latLng,
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
        _busToTrackState.removeWhere((bus) => bus.numero == linha);
        _dfTransBuses.remove(linha);
        _markers.removeWhere((item) => item.markerId.value.contains(linha));
        _deletedLines.add(linha);
    }

    void _watchUserLocation(LocationData data) {
        setState(() => _latLng = LatLng(data.latitude, data.longitude));
    }

    void _watchBusLocation([Timer timer]) {
        if (_cancelTimer) return timer.cancel();

        _busToTrackState.forEach((item) async {
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

    }
}
