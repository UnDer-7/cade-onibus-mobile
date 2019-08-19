import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './routes.dart';

import './pages/home_page.dart';
import './pages/auth_page.dart';

import './providers/user_provider.dart';
import './providers/bus_selected.dart';

import './services/jwt_service.dart';
import './services/check_status_service.dart';

import './utils/custom_colors.dart';
import './utils/jwt.dart';

import './stateful_wrapper.dart';

void main() {
//    debugPaintSizeEnabled = true;
//    debugPaintPointersEnabled = true;
    runApp(CadeVan());
}

class CadeVan extends StatelessWidget {
    final UserProviders userProviders = UserProviders();
    final StreamController<StartupState> _startupStatus = StreamController<StartupState>();
    bool _dfTransStatus;

    @override
    MultiProvider build(BuildContext context) {
        return MultiProvider(
            providers: [
                ChangeNotifierProvider.value(
                    value: userProviders,
                ),
                ChangeNotifierProvider<BusSelected>.value(
                    value: BusSelected(),
                )
            ],
            child: MaterialApp(
                title: 'Cadê Ônibus',
                theme: ThemeData(
                    primarySwatch: CustomColors.primaryColor,
                    accentColor: CustomColors.primaryColor,
                ),
                home: StatefulWrapper(
                    onInit: () => _loadFutures(isError: true),
                    child: StreamBuilder<StartupState>(
                        stream: _startupStatus.stream,
                        builder: (ctx, snap) => _handleHomePageLoad(snap),
                    ),
                ),
                routes: Routes.availableRoutes,
            ),
        );
    }

    Future<void> _loadFutures({bool isError = false}) async {
        _startupStatus.add(StartupState.BUSY);
        try {
            final canActivate = await JWTService.canActivate();

            if (!canActivate) {
                _startupStatus.add(StartupState.AUTH_PAGE);
                return;
            }

            final token = await JWT.getToken();
            final user = await UserProviders.findUser(token.payload.email);
            _dfTransStatus = await CheckStatusService.isDFTransAvailable();
            userProviders.setCurrentUser(user);

            _startupStatus.add(StartupState.HOME_PAGE);
        } catch (err, stack) {
            print('Erro ao carregar Futures de inicialização');
            print('ERROR: \n$err');
            print('StackTrack: \t$stack');
            _startupStatus.add(StartupState.ERROR);
            throw err;
        }
    }

    _handleHomePageLoad(AsyncSnapshot<StartupState> snap) {
        if (!snap.hasData || snap.data == StartupState.BUSY) {
            return Center(
                child: CircularProgressIndicator(),
            );
        }

        if (snap.hasError) {
            print('User will be send to AuthPage because snapShot has error');
            print('SNAP_SHOT ERROR\n${snap.error}');
            return AuthPage();
        }

        if (!snap.hasData || snap.data == StartupState.ERROR) {
            print('User will be send to AuthPage because StartupState is ${snap.data}');
            return AuthPage();
        }

        if (!snap.hasData || snap.data == StartupState.AUTH_PAGE) {
            return AuthPage();
        }

        if (!snap.hasData || snap.data == StartupState.HOME_PAGE) {
            return HomePage(_dfTransStatus, false);
        }

        print('User will be send to AuthPage because it didnt fall in any of the IFs');
        print('SNAP_DATA - \t${snap.data}');
        return AuthPage();
    }
}

enum StartupState { BUSY, ERROR, HOME_PAGE, AUTH_PAGE }
