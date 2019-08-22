import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './routes.dart';

import './pages/home_page.dart';
import './pages/auth/main_auth_page.dart';

import './providers/user_provider.dart';
import './providers/bus_selected.dart';

import './services/jwt_service.dart';
import './services/check_status_service.dart';
import './services/logger_service.dart';

import './utils/custom_colors.dart';
import './utils/jwt.dart';

import './stateful_wrapper.dart';

void main() {
    LoggerService('Main').info(text: 'Starting the App', methodName: 'main');
//    debugPaintSizeEnabled = true;
//    debugPaintPointersEnabled = true;
    runApp(CadeVan());
}

class CadeVan extends StatelessWidget {
    final UserProviders userProviders = UserProviders();
    final StreamController<StartupState> _startupStatus = StreamController<StartupState>();
    final LoggerService _logger = LoggerService('CadeVan');
    bool _dfTransStatus;

    /// todo EveryStartup send LOGGES to backen
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
        _logger.info(text: 'Starting to load Futures', methodName: '_loadFutures');
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
            _saveHowManyTimesGoToMainAuthPage();
            return MainAuthPage();
        }

        if (!snap.hasData || snap.data == StartupState.ERROR) {
            print('User will be send to AuthPage because StartupState is ${snap.data}');
            _saveHowManyTimesGoToMainAuthPage();
            return MainAuthPage();
        }

        if (!snap.hasData || snap.data == StartupState.AUTH_PAGE) {
            _saveHowManyTimesGoToMainAuthPage();
            return MainAuthPage();
        }

        if (!snap.hasData || snap.data == StartupState.HOME_PAGE) {
            return HomePage(_dfTransStatus, false);
        }

        print('User will be send to AuthPage because it didnt fall in any of the IFs');
        print('SNAP_DATA - \t${snap.data}');
        return MainAuthPage();
    }

    void _saveHowManyTimesGoToMainAuthPage() {
        SharedPreferences.getInstance().then((res) {

            int opened = res.getInt(SharedPreferencesKeys.APP_OPEN_COUNT.toString());
            if (opened == null) {
                res.setInt(SharedPreferencesKeys.APP_OPEN_COUNT.toString(), 1);
            } else {
                final newOpened = opened + 1;
                res.setInt(SharedPreferencesKeys.APP_OPEN_COUNT.toString(), newOpened);
            }
        });
    }
}

enum StartupState { BUSY, ERROR, HOME_PAGE, AUTH_PAGE }
