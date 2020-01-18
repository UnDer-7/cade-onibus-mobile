import 'dart:convert';

import 'package:catcher/core/catcher.dart';
import 'package:dio/dio.dart';

import './resource_exception.dart';
import '../environments/environment.dart';

abstract class AuthResource{
    static final String _emailUrl = '${Environment.api}/session/email';
    static final String _googleUrl = '${Environment.api}/session/google';
    static final String _recoveryUrl = '${Environment.api}/session/recovery';
    static final String _refreshTokenUrl = '${Environment.api}/session/refresh';

    static final Dio _dio = Dio();

    static Future<String> loginWithEmail(final String email, final String password) async {
        print('POST request login with Email\tURL: $_emailUrl');
        Map<String, String> user = {
            'email': email,
            'password': password,
        };
        try {
            final response = await _dio.post(_emailUrl, data: json.encode(user));
            return response.data;
        } on DioError catch (err, stack) {
            if (err.response == null) {
                Catcher.reportCheckedError(err, stack);
                throw ResourceException(
                    'Operação falhou',
                    classOrigin: 'AuthResource',
                    methodOrigin: 'loginWithEmail',
                    lineOrigin: '35',
                );
            }
            if (err.response.data == 'resource-not-found' && err.response.statusCode == 404) {
                throw ResourceException('Usuário não encontrado');
            }

            if (err.response.data == 'email-used-on-google' && err.response.statusCode == 400) {
                throw ResourceException('E-Mail cadastrado com Google\nTente entrar com Google');
            }

            if (err.response.data == 'invalid-credentials' && err.response.statusCode == 400) {
                throw ResourceException('Senha incorreta');
            }

            Catcher.reportCheckedError(err, stack);
            throw ResourceException(
                'Operação falhou',
                classOrigin: 'AuthResource',
                methodOrigin: 'loginWithEmail',
                lineOrigin: '35',
            );
        } catch (generic, stack) {
            print('Erro INESPERADO no loginWithEmail');
            print('Error -> \t$generic');
            print('StackTrace: \t$stack');
            Catcher.reportCheckedError(generic, stack);
            throw generic;
        }
    }

    static Future<void> recoveryPassword(final String email) async {
        print('POST request to $_recoveryUrl');
        final map = {
            'email': email,
        };

        try {
            await _dio.post(_recoveryUrl, data: json.encode(map));
        } on DioError catch (err, stack) {
            if (err.response == null) {
                Catcher.reportCheckedError(err, stack);
                throw ResourceException(
                    'Operação falhou',
                    classOrigin: 'AuthResource',
                    methodOrigin: 'recoveryEmail',
                    lineOrigin: '70',
                );
            }

            if (err.response.data == 'resource-not-found' && err.response.statusCode == 404) {
                throw ResourceException('E-mail não encontrato');
            }

            Catcher.reportCheckedError(err, stack);
            throw ResourceException(
                'Operação falhou',
                classOrigin: 'AuthResource',
                methodOrigin: 'loginWithEmail',
                lineOrigin: '70',
            );
        } catch (err, stack) {
            Catcher.reportCheckedError(err, stack);
            throw err;
        }
    }

    static Future<String> loginWithGoogle(final String email, final String googleId) async {
        print('POST request login with Google\tURL: $_googleUrl');
        final Map<String, String> user = {
            'email': email,
            'google_id': googleId,
        };

        try {
            final response = await _dio.post(_googleUrl, data: json.encode(user));
            return response.data;
        } on DioError catch (err, stack) {
            if (err.response == null) {
                Catcher.reportCheckedError(err, stack);
                throw ResourceException(
                    'Operação falhou',
                    classOrigin: 'AuthResource',
                    methodOrigin: 'loginWithEmail',
                    lineOrigin: '35',
                );
            }
            if (err.response.data == 'resource-not-found' && err.response.statusCode == 404) {
                throw ResourceException('Usuário não encontrado');
            }

            if (err.response.data == 'invalid-credentials' && err.response.statusCode == 400) {
                throw ResourceException('Senha incorreta');
            }

            if (err.response.data == 'can-crate' && err.response.statusCode == 400) {
                throw ResourceException('already-in-use');
            }
            Catcher.reportCheckedError(err, stack);
        } catch (generic, stack) {
            print('Erro INESPERADO no loginWithGoogle');
            print('Error -> \t$generic');
            print('StackTrace: \t$stack');
            Catcher.reportCheckedError(generic, stack);
            throw generic;
        }
    }
    
    static Future<String> refreshToken(final String token) async {
        print('POST Request to refresh Token\tURL: $_refreshTokenUrl');

        final Map<String, String> tokenMap = {
            'token': token,
        };

        try {
            final response = await _dio.post(_refreshTokenUrl, data: json.encode(tokenMap));
            return response.data;
        } on DioError catch (err, stack) {
            if (err.response == null) {
                Catcher.reportCheckedError(err, stack);
                throw ResourceException(
                    'Operação falhou',
                    classOrigin: 'AuthResource',
                    methodOrigin: 'refreshToken',
                    lineOrigin: '149',
                );
            }
            Catcher.reportCheckedError(err, stack);
            throw ResourceException(
                'Operação falhou',
                classOrigin: 'AuthResource',
                methodOrigin: 'loginWithEmail',
                lineOrigin: '70',
            );
        } catch (err, stack) {
            Catcher.reportCheckedError(err, stack);
            throw err;
        }
    }
}
