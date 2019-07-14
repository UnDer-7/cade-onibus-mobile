import 'package:dio/dio.dart';

import '../models/bus.dart';

abstract class DFTransResource {
    static final Dio _dio = Dio();
    static final String _resourceUrl = 'https://www.sistemas.dftrans.df.gov.br';

    static Future<List<Bus>> findBus(String param) {
        return _dio.get<List<dynamic>>('$_resourceUrl/linha/find/$param')
            .then((item) => item.data.map((bus) => Bus.fromJson(bus)).toList());
    }
}
