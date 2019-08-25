import 'package:dio/dio.dart';

import '../utils/jwt.dart';

abstract class DioConfig {
    static Dio dioFactory() {
        return Dio()..interceptors.add(
            InterceptorsWrapper(
                onRequest: (RequestOptions options) async {
                    final jwt = await JWT.getToken();
                    options.headers.addAll({'Authorization': 'Bearer ${jwt.jwtEncoded}'});
                    return options;
                }
            ),
        );
    }
}
