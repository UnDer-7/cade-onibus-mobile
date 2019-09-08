import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:catcher/catcher_plugin.dart';

import './pages/home_page.dart';
import './pages/auth/main_auth_page.dart';

import './providers/user_provider.dart';
import './providers/bus_selected.dart';

import './utils/custom_colors.dart';
import './utils/jwt.dart';

import './routes.dart';
import './services/jwt_service.dart';
import './config/catcher_config.dart';
import './stateful_wrapper.dart';

void main() {
    CatcherConfig config = CatcherConfig();
    Catcher(
        CadeOnibus(),
        debugConfig: config.debugConfig(),
        profileConfig: config.releaseConfig(),
        releaseConfig: config.releaseConfig(),
        enableLogger: true,
    );
}

class CadeOnibus extends StatelessWidget {
    final UserProviders userProviders = UserProviders();
    final StreamController<StartupState> _startupStatus = StreamController<StartupState>();

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
                navigatorKey: Catcher.navigatorKey,
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
            userProviders.setCurrentUser(user);

            _startupStatus.add(StartupState.HOME_PAGE);
        } catch (err, stack) {
            print('Erro ao carregar Futures de inicialização');
            print('ERROR: \n$err');
            print('StackTrack: \t$stack');
            _startupStatus.add(StartupState.ERROR);
            Catcher.reportCheckedError(err, stack);
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
            return MainAuthPage();
        }

        if (!snap.hasData || snap.data == StartupState.ERROR) {
            print('User will be send to AuthPage because StartupState is ${snap.data}');
            return MainAuthPage();
        }

        if (!snap.hasData || snap.data == StartupState.AUTH_PAGE) {
            return MainAuthPage();
        }

        if (!snap.hasData || snap.data == StartupState.HOME_PAGE) {
            return HomePage(false);
        }

        print('User will be send to AuthPage because it didnt fall in any of the IFs');
        print('SNAP_DATA - \t${snap.data}');
        return MainAuthPage();
    }
}

enum StartupState { BUSY, ERROR, HOME_PAGE, AUTH_PAGE }
