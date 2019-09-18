import 'dart:convert';

import 'package:catcher/core/catcher.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/dio_config.dart';
import '../utils/api_util.dart';
import '../models/user.dart';
import './resource_exception.dart';

abstract class UserResource {
    static final Dio _dioAuth = DioConfig.dioFactory();
    static final Dio _dio = Dio();
    static final String _resourceUrl = '${APIUtil.api}/users';

    static Future<User> getUser(String email) async {
        print('GET request to get user \tURL: $_resourceUrl/$email');
        return _dioAuth.get(_resourceUrl + '/$email')
            .then((res) => res.data)
            .then((user) => User.fromJSON(user));
    }

    static Future<User> createUserWithGoogle(final GoogleSignInAccount google) async {
        print('POST request create user with Google\tURL: $_resourceUrl');
        final Map<String, String> user = {
            'email': google.email,
            'google_id': google.id,
            'name': google.displayName,
        };

        try {
            final res = await _dio.post(_resourceUrl, data: json.encode(user), queryParameters: {'type': 'google'});
            return User.fromJSON(res.data);
        } on DioError catch(err, stack) {
            if (err.response.data == 'can-crate' && err.response.statusCode == 400) {
                throw ResourceException('can-crate');
            }
            if (err.response.data == 'resource-already-exists' && err.response.statusCode == 400) {
                throw ResourceException('Usuário já cadastrado');
            }
            Catcher.reportCheckedError(err, stack);
            throw ResourceException(
                'Operação falhou',
                classOrigin: 'AuthResource',
                methodOrigin: 'loginWithEmail',
                lineOrigin: '35',
            );
        } catch (err, stack) {
            Catcher.reportCheckedError(err, stack);
            throw err;
        }
    }

    static associateEmailPasswordWithGoogle(final GoogleSignInAccount google, final String password) async {
        print('POST request associate accounts\tURL: $_resourceUrl/associate/email');
        final Map<String, String> user = {
            'email': google.email,
            'google_id': google.id,
            'name': google.displayName,
            'password': password,
        };

        try {
            final res = await _dio.post('$_resourceUrl/associate/email', data: json.encode(user));
            return User.fromJSON(res.data);
        } on DioError catch(err, stack) {
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
        } catch (err, stack) {
            Catcher.reportCheckedError(err, stack);
            throw err;
        }
    }

    static Future<User> associateAccounts(final GoogleSignInAccount google, final String password) async {
        print('POST request associate accounts\tURL: $_resourceUrl/associate');
        final Map<String, String> user = {
          'email': google.email,
          'google_id': google.id,
          'name': google.displayName,
          'password': password,
        };

        try {
            final res = await _dio.post('$_resourceUrl/associate', data: json.encode(user));
            return User.fromJSON(res.data);
        } on DioError catch(err, stack) {
            if (err.response.data == 'resource-already-exists' && err.response.statusCode == 404) {
                throw ResourceException('Já existe uma senha associada a esse E-mail');
            }

            if (err.response.data == 'invalid-credentials' && err.response.statusCode == 404) {
                throw ResourceException('Usuário não tem uma conta para ser associada!');
            }

            if (err.response.data == 'resource-not-found' && err.response.statusCode == 404) {
                throw ResourceException('Usuário não tem uma conta do Google cadastrada');
            }
            Catcher.reportCheckedError(err, stack);
            throw ResourceException(
                'Operação falhou',
                classOrigin: 'AuthResource',
                methodOrigin: 'loginWithEmail',
                lineOrigin: '35',
            );
        } catch (err, stack) {
            Catcher.reportCheckedError(err, stack);
            throw err;
        }
    }

    static Future<User> createUserWithEmail(final String email, final String password) async {
        print('POST request create user with Email\tURL: $_resourceUrl');
        final Map<String, String> user = {
            'email': email,
            'password': password,
        };

        try {
            final res = await _dio.post(_resourceUrl, data: json.encode(user), queryParameters: {'type': 'email'});
            return User.fromJSON(res.data);
        } on DioError catch(err, stack) {
            if (err.response.data == 'can-crate' && err.response.statusCode == 400) {
                throw ResourceException('can-crate');
            }

            if (err.response.data == 'resource-already-exists' && err.response.statusCode == 400) {
                throw ResourceException('E-mail já cadastrado');
            }

            Catcher.reportCheckedError(err, stack);
            throw ResourceException(
                'Operação falhou',
                classOrigin: 'AuthResource',
                methodOrigin: 'loginWithEmail',
                lineOrigin: '35',
            );
        } catch (err, stack) {
            Catcher.reportCheckedError(err, stack);
            throw err;
        }
    }
}
