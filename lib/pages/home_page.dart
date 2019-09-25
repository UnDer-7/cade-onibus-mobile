import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../pages/new_bus_page.dart';
import '../pages/map_page.dart';

import '../providers/user_provider.dart';
import '../providers/bus_selected.dart';

import '../services/jwt_service.dart';

import '../models/bus.dart';
import '../routes.dart';
import '../widgets/bus_category.dart';
import '../utils/toast_util.dart';

class HomePage extends StatefulWidget {
    final bool _isNewUser;

    HomePage(this._isNewUser);

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
        final BusSelected _busSelected = Provider.of<BusSelected>(context, listen: false);

        return Scaffold(
            appBar: AppBar(
                title: Text('Cadê Ônibus'),
            ),
            floatingActionButton: SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                children: [
                    SpeedDialChild(
                        label: 'Rastrear Ônibus',
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
//                    SpeedDialChild(
//                        onTap: _toBeImplemented,
//                        label: 'Melhorias/Bugs',
//                        child: Icon(Icons.bug_report)
//                    ),
                    SpeedDialChild(
                        onTap: _toBeImplemented,
                        label: 'Sobre o app',
                        child: Icon(Icons.info),
                    ),
                    SpeedDialChild(
                        label: 'Sair',
                        child: Icon(Icons.exit_to_app),
                        onTap: () => JWTService.singOut(context),
                    )
                ],
            ),
            body: Consumer<UserProviders>(
                builder: (_, UserProviders model, Widget ig) =>
                    ListView.builder(
                        itemCount: model.getCategory.length,
                        itemBuilder: (BuildContext ctx, int i) =>
                            BusCategory(model.getCategory[i]),
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

    Future<void> _onTrackBus(BuildContext context, final BusSelected busSelected) async {
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

    void _toBeImplemented() {
        ToastUtil.showToast('Funcionalidade em Desenvolvimento', context, color: ToastUtil.warning, position: ToastUtil.bottom);
    }

}
