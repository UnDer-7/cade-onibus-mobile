import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/jwt_service.dart';
import '../../services/check_status_service.dart';

import './main_auth_page.dart';
import '../map_page.dart';
import '../../utils/toast_util.dart';

class LandPage extends StatelessWidget {
    final PageController _pageController;

    LandPage(this._pageController);

    @override
    Scaffold build(BuildContext context) {
        return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Stack(
                    children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: SvgPicture.asset(
                                    'assets/images/bus_stop_backgroud_2.svg',
                                    semanticsLabel: 'background',
                                    alignment: Alignment.topCenter,
                                ),
                            ),
                        ),
                        Positioned(
                            top: 230,
                            left: 0,
                            right: 0,
                            child: Text(
                                'Cadê Ônibus',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 40,
                                    color: Colors.white,
                                ),
                            ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 140),
                          child: Align(
                              alignment: Alignment.bottomCenter,
                            child: SizedBox(
                                width: double.infinity,
                              child: OutlineButton(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                      'Entrar',
                                      style: TextStyle(
                                          color: Colors.white,
                                      ),
                                  ),
                                  onPressed: () => _navigateTo(MainAuthPage.signIn),
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                  ),
                              ),
                            ),
                          ),
                        ),
//                        SizedBox(height: 15),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 70),
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                    width: double.infinity,
                                    child: RaisedButton(
                                        child: Text(
                                            'Nova Conta',
                                            style: TextStyle(
                                                color: Theme.of(context).primaryColor,
                                            ),
                                        ),
                                        color: Colors.white,
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                        onPressed: () => _navigateTo(MainAuthPage.signUp),
                                    ),
                                ),
                            ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: FlatButton(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                onPressed: () => _navigateToMapPage(context),
                                child: Text(
                                    'Só quero procurar um ônibus',
                                    style: TextStyle(
                                        color: Colors.white,
                                    ),
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    void _navigateTo(final int pageNumber) {
        _pageController.animateToPage(
            pageNumber,
            duration: Duration(milliseconds: 800),
            curve: Curves.fastOutSlowIn,
        );
    }

    Future<void> _navigateToMapPage(BuildContext ctx) async {
        if (!await _isInternetOn(ctx)) {
            return;
        }

        final hasPermission = await CheckStatusService.hasLocationPermission();
        if (!hasPermission) {
            CheckStatusService.showGPSRequiredDialog(ctx, true);
            return;
        }

        final isGPSAvailable = await CheckStatusService.isGPSAvailable();
        if (!isGPSAvailable) {
            CheckStatusService.showGPSRequiredDialog(ctx);
            return;
        }

        await _saveHowManyTimesOpenMap();
        final answer = await _showCreateAccountDialog(ctx);
        if (answer == null) return;
        if (answer) {
            _navigateTo(MainAuthPage.signUp);
            return;
        }
        final userLocation = await Location().getLocation();

        Navigator.push(ctx, MaterialPageRoute(
            builder: (_) => MapPage(
                busesToTrack: [],
                initialLocation: LatLng(userLocation.latitude, userLocation.longitude)
            ),
        ));
    }

    Future<void> _saveHowManyTimesOpenMap() async {
        final res = await SharedPreferences.getInstance();
        int opened = res.getInt(SharedPreferencesKeys.APP_OPEN_COUNT.toString());
        if (opened == null) {
            res.setInt(SharedPreferencesKeys.APP_OPEN_COUNT.toString(), 1);
        } else {
            final newOpened = opened + 1;
            res.setInt(SharedPreferencesKeys.APP_OPEN_COUNT.toString(), newOpened);
        }
    }

    Future<bool> _showCreateAccountDialog(BuildContext context) async {
        final SharedPreferences preferences = await SharedPreferences.getInstance();
        int opened = preferences.getInt(SharedPreferencesKeys.APP_OPEN_COUNT.toString());
        if (opened > 5) {
            final answer = await showDialog(
                context: context,
                builder: (BuildContext ctx) => AlertDialog(
                    title: Text('Vamos Criar uma Conta?'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    content: Text(
                        'Você já esta usando o Cadê Ônibus a algum tempo, que tal criar uma conta?\n\n'
                            'Com a conta você pode salvar seu ônibus mais utilizado em categorias criadas por você.'
                    ),
                    actions: <Widget>[
                        FlatButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(
                                'Mais Tarde',
                                style: TextStyle(
                                    color: Colors.red,
                                ),
                            ),
                        ),
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
            return Future.value(answer);
        }
        return Future.value(false);
    }

    Future<bool> _isInternetOn(BuildContext context) async {
        final isInternetOn = await CheckStatusService.isInternetAvailable();
        if (!isInternetOn) {
            ToastUtil.showToast('Sem conexão com a internet', context, color: ToastUtil.warning);
            return false;
        }
        return true;
    }
}
