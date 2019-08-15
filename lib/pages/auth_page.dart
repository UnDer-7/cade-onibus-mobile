import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthPage extends StatelessWidget {
    @override
    Scaffold build(BuildContext context) {
        final double _width = MediaQuery.of(context).size.width;
        final double _height = MediaQuery.of(context).size.height;

        return Scaffold(
            body: Stack(
                children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                end: Alignment.bottomLeft,
                                begin: Alignment.topRight,
                                colors: [
                                    Color(4285547775),
                                    Colors.pink,
                                ]
                            )
                        ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                              'Cadê Ônibus',
                              style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 40,
                                  color: Colors.white,
                              ),
                          ),
                      ),
                    ),
                    SvgPicture.asset('assets/images/bus_stop_backgroud.svg'),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            margin: EdgeInsets.only(bottom: 70),
                            width: _width / 1.3,
                            height: _height / 2.7,
                            child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                            TextFormField(
                                                keyboardType: TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                    labelText: 'E-mail',
                                                ),
                                            ),
                                            TextFormField(
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                    labelText: 'Password',
                                                ),
                                            ),
                                            SizedBox(height: 15),
                                            _buildEntrarButton(context),
                                            _buildDivider(context),
                                            _buildGoogleButton(context),
                                        ],
                                    ),
                                ),
                            ),
                        ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: _buildNewUserButton(context),
                    ),
                ],
            ),
        );
    }

    RaisedButton _buildEntrarButton(BuildContext context) =>
        RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: Theme.of(context).primaryColor,
            onPressed: () {},
            child: Text(
                'Entrar',
                style: TextStyle(
                    color: Colors.white,
                ),
            ),
        );

    Row _buildDivider(BuildContext context) =>
        Row(
            children: <Widget>[
                Expanded(
                    child: Divider(
                        color: Theme.of(context).primaryColor,
                        height: 30,
                    )
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Ou"),
                ),
                Expanded(
                    child: Divider(
                        color: Theme.of(context).primaryColor,
                    )
                ),
            ]
        );

    OutlineButton _buildGoogleButton(BuildContext context) =>
        OutlineButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).primaryColor,
            ),
            onPressed: () {},
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    SvgPicture.asset(
                        'assets/images/google_icon.svg',
                        height: 30,
                        width: 30,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Entrar com Google'),
                    ),
                ],
            ),
        );
    
    Row _buildNewUserButton(BuildContext context) =>
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Text(
                    'Novo usuario?',
                    style: TextStyle(
                        color: Colors.white,
                    ),
                ),
                FlatButton(
                    onPressed: () {},
                    child: Text(
                        'Criar Conta',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                        ),
                    ),
                ),
            ],
        );
}
