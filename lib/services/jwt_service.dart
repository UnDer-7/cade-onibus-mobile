import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import './service_exception.dart';
import '../models/token.dart';
import '../utils/jwt.dart';

abstract class JWTService {
    static Future<Token> saveUser(String jwt) async {
        try {
            final preferences = await SharedPreferences.getInstance();
            final token = JWT.decode(jwt);
            final json = Token.toJSON(token);
            final didSave = await preferences.setString(SharedPreferencesKeys.TOKEN.toString(), json);
            if (!didSave) {
                throw ServiceException(
                    'Unable to save token on SharedPreferences',
                    classOrigin: 'JWTService',
                    methodOrigin: 'saveUser',
                    lineOrigin: '12',
                );
            }
            return token;
        } catch(err, stack) {
            print('Something went wrong when accessing SharedPreferences!');
            print('StackTrace\n$stack');
            throw err;
        }
    }

    static Future<bool> canActivate() async {
        final token = await JWT.getToken();
        if (token == null) {
            return false;
        }
        return token.payload.exp.isAfter(DateTime.now());
    }
}

class JWTServiceException implements Exception {
    final String msg;
    JWTServiceException(this.msg);
}

enum SharedPreferencesKeys {
    TOKEN,
    APP_OPEN_COUNT,
}
