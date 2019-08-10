import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../models/bus.dart';
import '../routes.dart';
import '../widgets/bus_category.dart';

import '../pages/new_bus_page.dart';
import '../pages/map_page.dart';

import '../providers/user_provider.dart';
import '../providers/bus_selected.dart';

class HomePage extends StatelessWidget {

    @override
    Scaffold build(BuildContext context) {
        final BusSelected _busSelected = Provider.of<BusSelected>(context, listen: false);

        return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text('Cadê Ônibus'),
            ),
            floatingActionButton: SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                children: [
                    SpeedDialChild(
                        onTap: () => _onTrackBus(context, _busSelected),
                        child: Icon(Icons.directions_bus),
                        label: 'Rastrar Ônibus'
                    ),
                    SpeedDialChild(
                        onTap: () =>
                            Navigator.pushNamed(
                                context, Routes.NEW_CATEGORY_PAGE),
                        child: Icon(Icons.category),
                        label: 'Nova Categoria'
                    ),
                ],
            ),
            body: Consumer<UserProviders>(
                builder: (_, UserProviders model, Widget widget) =>
                    ListView.builder(
                        itemCount: model.getCategory.length,
                        itemBuilder: (BuildContext ctx, int i) =>
                            BusCategory(model.getCategory[i]),
                    ),
            ),
        );
    }

    Future _onTrackBus(BuildContext context, final BusSelected busSelected) async {
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
}
