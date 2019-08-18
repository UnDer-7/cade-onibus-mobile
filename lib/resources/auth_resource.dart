import 'package:dio/dio.dart';
import 'dart:convert';

import './resource_exception.dart';
import '../utils/api_util.dart';

abstract class AuthResource{
    static final String _emailUrl = '${APIUtil.api}/session/email';
    static final Dio _dio = Dio();

    static Future<String> loginWithEmail(final String email, final String password) async {
        Map<String, String> user = {
            'email': email,
            'password': password,
        };

        print('${DateTime.now()} - POST request to: $_emailUrl');
        try {
            final response = await _dio.post(_emailUrl, data: json.encode(user));
            return response.data;
        } on DioError catch (err) {
            if (err.response.data == 'resource-not-found' && err.response.statusCode == 404) {
                throw ResourceException('Usuário não encontrado');
            }

            if (err.response.data == 'invalid-credentials' && err.response.statusCode == 400) {
                throw ResourceException('Senha incorreta');
            }

            print('Erro ao realizar request para {$_emailUrl} - Metodo: loginWithEmail | Class: AuthResource');
            print('Response -> \t${err.response}');
            print('Message -> \t${err.message}');
            print('Error -> \t${err.error}');
            print('statusCode -> \t${err.response.statusCode}');
            throw ResourceException(
                'Operação falhou',
                classOrigin: 'AuthResource',
                methodOrigin: 'loginWithEmail',
                lineOrigin: '35',
            );
        } catch (generic) {
            print('Erro INESPERADO no loginWithEmail');
            print('Error -> \t$generic');
            throw generic;
        }
    }
}
