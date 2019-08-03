import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import './routes.dart';

import './utils/custom_colors.dart';
import './models/user.dart';
import './pages/home_page.dart';
import './providers/user_provider.dart';
import './providers/bus_selected.dart';

void main() {
//    debugPaintSizeEnabled = true;
//    debugPaintPointersEnabled = true;
    runApp(CadeVan());
}

class CadeVan extends StatelessWidget {
    final UserProviders userProviders = UserProviders();

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
                home: FutureBuilder(
                    future: UserProviders.findUser('mateus7532@gmail.com'),
                    builder: (BuildContext ctx, AsyncSnapshot<User> snapshot) {
                        switch (snapshot.connectionState) {
                            case ConnectionState.waiting: return _handleWaitingCase(context);
                            default: return _handleDefaultCase(snapshot);
                        }
                    },
                ),
                routes: Routes.availableRoutes,
            ),
        );
    }

    Widget _handleWaitingCase(BuildContext context) =>
        Container(
            color: Colors.purple,
            child: Center(
                child: CircularProgressIndicator()
            ),
        );

    Widget _handleDefaultCase(AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
            print('ERROR\n${snapshot.error}');
            return Center(child: Text(
                'DEU ERROR!\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20
                ),
            ));
        }

        final User user = snapshot.data;
        userProviders.setCurrentUser(user);
        return HomePage();
    }
}
