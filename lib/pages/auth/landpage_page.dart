import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import './main_auth_page.dart';
import '../map_page.dart';

class LandPage extends StatelessWidget {
    final PageController _pageController;

    LandPage(this._pageController);

    @override
    Scaffold build(BuildContext context) {
        final double _height = MediaQuery.of(context).size.height;

        return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                        Text(
                            'Cadê Ônibus',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 40,
                                color: Colors.white,
                            ),
                        ),
                        SvgPicture.asset(
                            'assets/images/bus_stop_backgroud_2.svg',
                            semanticsLabel: 'background',
                            alignment: Alignment.topCenter,
                        ),
                        OutlineButton(
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
                        SizedBox(height: 15),
                        Padding(
                            padding: EdgeInsets.only(bottom: _height / 15),
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
                        FlatButton(
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
                    ],
                ),
            ),
        );
    }

    void _navigateTo(final int pageNumber) {
        _pageController.animateToPage(
            pageNumber,
            duration: Duration(milliseconds: 800),
            curve: Curves.bounceOut,
        );
    }

    Future<void> _navigateToMapPage(BuildContext ctx) async {
        final userLocation = await Location().getLocation();

        Navigator.push(ctx, MaterialPageRoute(
            builder: (_) => MapPage(
                busesToTrack: [],
                initialLocation: LatLng(userLocation.latitude, userLocation.longitude)
            ),
        ));
    }
}
