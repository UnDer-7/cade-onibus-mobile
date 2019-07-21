import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapTab extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return GoogleMap(
            markers: _busMarkers,
            initialCameraPosition: CameraPosition(
                zoom: 16,
                target: LatLng(37.422, -122.084),
            ),
        );
    }

    Set<Marker> get _busMarkers =>
        {
            Marker(
                markerId: MarkerId('eae'),
                position: LatLng(37.422, -122.084),
            ),
        };

    get userLocation async {
        final location = Location();
        final current = await location.getLocation();
    }
}
