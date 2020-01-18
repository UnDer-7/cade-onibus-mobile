import 'package:dio/dio.dart';

import '../models/token.dart';
import '../utils/jwt.dart';
import '../resources/auth_resource.dart';
import '../services/jwt_service.dart';

abstract class DioConfig {
    static Dio dioFactory() {
        return Dio()..interceptors.add(
            InterceptorsWrapper(
                onRequest: (RequestOptions options) async {
                    var jwt = await JWT.getToken();
                    if (canRefreshToken(jwt)) {
                        final res = await AuthResource.refreshToken(jwt.jwtEncoded);
                        await JWT.removeToken();
                        jwt = await JWTService.saveToken(res);
                    }
                    options.headers.addAll({'Authorization': 'Bearer ${jwt.jwtEncoded}'});
                    return options;
                }
            ),
        );
    }

    static bool canRefreshToken(final Token jwt) {
        final currentDate = DateTime.now();

        final diffDays = currentDate.difference(jwt.payload.exp).inDays;
        return diffDays < 10;
    }
}
