import 'package:dio/dio.dart';

import '../models/bus.dart';
import '../models/bus_coordinates.dart';

abstract class DFTransResource {
    static final Dio _dio = Dio();
    static final String _resourceUrl = 'https://www.sistemas.dftrans.df.gov.br';

    static Future<List<Bus>> findBus(String param) {
        return _dio.get<List<dynamic>>('$_resourceUrl/linha/find/$param/10/short')
            .then((item) => item.data.map((bus) => Bus.fromJSON(bus)).toList());
    }

    static Future<List<BusCoordinates>> findBusLocation(String linha) {
        return _dio.get<Map<String, dynamic>>('$_resourceUrl/gps/linha/$linha/geo/recent')
            .then((response) => response.data['features'])
            .then((busesLocation) => busesLocation.map((busLocation) => BusCoordinates.fromJson(busLocation)).toList())
            .then((locationUntyped) => List<BusCoordinates>.from(locationUntyped));
    }
}
