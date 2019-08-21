import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../services/jwt_service.dart';
import '../services/logger_service.dart';

import './utils_exception.dart';
import '../models/token.dart';

abstract class JWT {
    static final LoggerService _logger = LoggerService('JWT');
    static Token decode(final String jwt) {
        final List<String> parts = jwt.split('.');

        final header = _decodeBase64(parts[0]);
        final payload = _decodeBase64(parts[1]);

        return Token.fromJSON(jwtEncoded: jwt, payload: json.decode(payload), header: json.decode(header));
    }

    static Future<Token> getToken() async {
        try {
            _logger.info(text: 'Starting to get Token from SharedPreferences', methodName: 'getToken');
            final preferences = await SharedPreferences.getInstance();
            preferences.remove(SharedPreferencesKeys.TOKEN.toString());
            final jsonRes = preferences.getString(SharedPreferencesKeys.TOKEN.toString());
            if (jsonRes == null) return null;
            return Token.fromSharedPreferences(json.decode(jsonRes));
        } catch (err) {
            _logger.error(
                text: 'Erro while attempt to get Token from SharedPreferences',
                methodName: 'getToken',
                exception: err);
            await _logger.exportLogs();
            throw err;
        }
    }

    static _decodeBase64(String text) {
        switch (text.length % 4) {
            case 0:
                break;
            case 2:
                text += '==';
                break;
            case 3:
                text += '=';
                break;
            default:
                throw UtilException('Invalid Base64');
        }
        return utf8.decode(Base64Codec().decode(text));
    }

}
