import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../pages/new_bus_page.dart';
import '../pages/map_page.dart';

import '../providers/user_provider.dart';
import '../providers/bus_selected.dart';

import '../services/check_status_service.dart';
import '../services/jwt_service.dart';

import '../utils/jwt.dart';
import '../utils/toast_util.dart';

import '../models/bus.dart';
import '../routes.dart';
import '../widgets/bus_category.dart';

class HomePage extends StatefulWidget {
    final bool _isNewUser;
    final bool internetStatus;

    HomePage(this._isNewUser, [this.internetStatus = true]);

    @override
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    bool _isLoading = false;
    bool _internetStatus;

    @override
    void initState() {
        _internetStatus = widget.internetStatus;
        if (widget._isNewUser) {
            Future.delayed(Duration.zero, () => _loadDialog(context));
        }
        super.initState();
    }
    @override
    Scaffold build(BuildContext context) {
        final BusSelected _busSelected = Provider.of<BusSelected>(context, listen: false);
        final UserProviders _userProvier = Provider.of<UserProviders>(context, listen: false);
        return getPageContent(_busSelected, _userProvier);
    }

    getPageContent(final BusSelected _busSelected, final UserProviders userProviders) {
        if (_internetStatus) {
            return Scaffold(
                appBar: AppBar(
                    title: Text('Cadê Ônibus'),
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

        return Scaffold(
            body: Stack(
                children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: SvgPicture.asset(
                              'assets/images/no_internet.svg',
                              width: 200,
                              height: 200,
                              color: Theme.of(context).primaryColor,
                          ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 150, left: 20, right: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                              Text(
                                  'Não foi possível estabelecer conexão com a internet',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30,
                                  ),
                              ),
                              SizedBox(height: 20),
                              RaisedButton(
                                  onPressed: () => _getCurrentUser(userProviders),
                                  child: Text(
                                      'Tentar Novamente',
                                      style: TextStyle(
                                          color: Colors.white,
                                      ),
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              ),
                          ],
                      ),
                    ),
                    if (_isLoading) Container(
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                        child: Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                        ),
                    )
                ],
            ),
        );
    }

    _getCurrentUser(final UserProviders userProviders) async {
        if (!await _isInternetOn()) {
            return;
        }

        try {
            _isLoading = true;
            final token = await JWT.getToken();
            final user = await UserProviders.findUser(token.payload.email);
            userProviders.setCurrentUser(user);
            setState(() => _internetStatus = true);
        } catch (err, stack) {
            Catcher.reportCheckedError(err, stack);
            ToastUtil.showToast('Algo deu errado', context, color: ToastUtil.error);
        } finally {
            _isLoading = false;
        }
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

    Future<bool> _isInternetOn() async {
        final isInternetOn = await CheckStatusService.isInternetAvailable();
        if (!isInternetOn) {
            ToastUtil.showToast('Sem conexão com a internet', context, color: ToastUtil.warning);
            return false;
        }
        return true;
    }

}
