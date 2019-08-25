import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../pages/new_bus_page.dart';
import '../pages/map_page.dart';

import '../providers/user_provider.dart';
import '../providers/bus_selected.dart';

import '../models/bus.dart';
import '../routes.dart';
import '../widgets/bus_category.dart';
import '../services/jwt_service.dart';

class HomePage extends StatefulWidget {
    final bool isDFTransAvailable;
    final bool _isNewUser;
    HomePage(this.isDFTransAvailable, this._isNewUser);

    @override
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    @override
    void initState() {
        if (widget._isNewUser) {
            Future.delayed(Duration.zero, () => _loadDialog(context));
        }
        super.initState();
    }
    @override
    Scaffold build(BuildContext context) {
        print('IS NEW USER -> ${widget._isNewUser}');
        final BusSelected _busSelected = Provider.of<BusSelected>(context, listen: false);

        return Scaffold(
            appBar: AppBar(
                title: Row(
                    children: <Widget>[
                        Text('Status DFTrans: '),
                        Text(
                            _getDFTransStatus,
                            style: TextStyle(
                                color: _getDFTransStatusColor,
                            ),
                        )
                    ],
                ),
            ),
            floatingActionButton: SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                children: [
                    SpeedDialChild(
                        label: 'Rastrar Ônibus',
                        child: Icon(Icons.directions_bus),
                        onTap: () => _onTrackBus(context, _busSelected),
                    ),
                    SpeedDialChild(
                        label: 'Nova Categoria',
                        child: Icon(Icons.category),
                        onTap: () =>
                            Navigator.pushNamed(
                                context, Routes.NEW_CATEGORY_PAGE)
                    ),
                    SpeedDialChild(
                        label: 'Melhorias/Bugs',
                        child: Icon(Icons.bug_report)
                    ),
                    SpeedDialChild(
                        label: 'Sobre o app',
                        child: Icon(Icons.info),
                    ),
                    SpeedDialChild(
                        label: 'Sair',
                        child: Icon(Icons.exit_to_app),
                        onTap: () => JWTService.singOut(context, widget.isDFTransAvailable),
                    )
                ],
            ),
            body: Consumer<UserProviders>(
                builder: (_, UserProviders model, Widget ig) =>
                    ListView.builder(
                        itemCount: model.getCategory.length,
                        itemBuilder: (BuildContext ctx, int i) =>
                            BusCategory(model.getCategory[i], widget.isDFTransAvailable),
                    ),
            ),
        );
    }

    Future<void> _loadDialog(BuildContext context) async {
        showDialog(
            context: context,
            builder: (BuildContext ctx) =>
                AlertDialog(
                    title: Text('Vamos criar uma categoria?'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    content: Text('Uma categoria serve para separa seus ônibus.\n'
                        'Tente criar uma chamada Casa com ônibus que vão para sua casa'),
                    actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                                Navigator.pop(ctx);
                                Navigator.pushNamed(context, Routes.NEW_CATEGORY_PAGE);
                            },
                            child: Text('Criar categoria'),
                        ),
                    ],
                ),
        );
    }

    String get _getDFTransStatus {
        if (widget.isDFTransAvailable) return 'Ativo';
        return 'Inativo';
    }

    Color get _getDFTransStatusColor {
        if (widget.isDFTransAvailable) return Colors.green;
        return Colors.red;
    }

    Future<void> _showDialogDFTransOff() async {
        await showDialog(
            context: context,
            builder: (BuildContext ctx) =>
                AlertDialog(
                    title: Text(
                        'DFTrans está indisponivel no momento!',
                        style: TextStyle(
                            color: Colors.red,
                        ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    content: Text('Com o DFTrans indisponivel você não consiguira achar nem um ônibus'),
                    actions: <Widget>[
                        FlatButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text(
                                'Ok',
                                style: TextStyle(
                                    color: Colors.green,
                                ),
                            ),
                        ),
                    ],
                ),
        );
    }

    Future<void> _onTrackBus(BuildContext context, final BusSelected busSelected) async {
        if (!widget.isDFTransAvailable) {
            await _showDialogDFTransOff();
        }

        final userLocation = await Location().getLocation();

        final response = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext ctx) => NewBusPage(isMultiSelection: true, isForSaving: false),
            )
        );

        if (response == null || response == false) {
            busSelected.cleanBusSelected();
            return;
        }

        Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext ct) => MapPage(
                initialLocation: LatLng(userLocation.latitude, userLocation.longitude),
                busesToTrack: List<Bus>.of(busSelected.getAllBusSelected)
            ),
        ));
    }
}
