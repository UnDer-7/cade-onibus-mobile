import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../utils/jwt.dart';
import '../utils/toast_util.dart';

import '../providers/user_provider.dart';
import '../services/check_status_service.dart';
import '../pages/home_page.dart';

class NoInternetPage extends StatefulWidget {
    @override
    _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
    bool _isLoading = false;

    @override
    Widget build(BuildContext context) {
        final UserProviders _userProvier = Provider.of<UserProviders>(context, listen: false);

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
                                    onPressed: () => _getCurrentUser(_userProvier, context),
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

    Future<bool> _isInternetOn(BuildContext context) async {
        final isInternetOn = await CheckStatusService.isInternetAvailable();
        if (!isInternetOn) {
            ToastUtil.showToast('Sem conexão com a internet', context, color: ToastUtil.warning);
            return false;
        }
        return true;
    }

    _getCurrentUser(final UserProviders userProviders, final BuildContext ctx) async {
        if (!await _isInternetOn(ctx)) {
            return;
        }

        try {
            setState(() => _isLoading = true);
            final token = await JWT.getToken();
            final user = await UserProviders.findUser(token.payload.email);
            userProviders.setCurrentUser(user);
            setState(() => _isLoading = false);
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext ctx) => HomePage(false),
            ));

        } catch (err, stack) {
            Catcher.reportCheckedError(err, stack);
            ToastUtil.showToast('Algo deu errado', ctx, color: ToastUtil.error);
        } finally {
            setState(() => _isLoading = false);
        }
    }
}
