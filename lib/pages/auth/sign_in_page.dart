import 'dart:async';

import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dio/dio.dart';

import '../../resources/auth_resource.dart';
import '../../resources/resource_exception.dart';
import '../../resources/users_resource.dart';

import '../../utils/toast_util.dart';
import '../../utils/validations.dart';

import '../../services/jwt_service.dart';
import '../../services/check_status_service.dart';

import './main_auth_page.dart';
import '../../pages/home_page.dart';
import '../../widgets/ou_divider.dart';
import '../../providers/user_provider.dart';

class SingInPage extends StatefulWidget {
    final PageController _pageController;
    final StreamController<bool> _isLoadingStream;

    SingInPage(this._pageController, this._isLoadingStream);

    @override
    _SingInPageState createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
    final GlobalKey<FormState> _formKey = GlobalKey();
    final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
            'email',
            'https://www.googleapis.com/auth/contacts.readonly',
        ],
    );

    String _password;
    String _email;
    bool _isLoading = false;
    bool _showPassword = false;
    bool _hasEmailFormError = false;
    bool _hasPasswordFormError = false;

    @override
    WillPopScope build(BuildContext context) {
        final UserProviders userProvider = Provider.of<UserProviders>(context, listen: false);
        final double _height = MediaQuery.of(context).size.height;

        return WillPopScope(
            onWillPop: () {
                if (_isLoading) {
                    return Future.value(false);
                }
                widget._pageController.animateToPage(
                    MainAuthPage.landPage,
                    duration: Duration(milliseconds: 800),
                    curve: Curves.bounceOut,
                );
                return Future.value(false);
            },
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Stack(
                    children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                        child: Form(
                                            key: _formKey,
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: <Widget>[
                                                    _buildEmailField(),
                                                    SizedBox(height: 15),
                                                    _buildPasswordField(),
                                                    SizedBox(height: 20),
                                                    RaisedButton(
                                                        onPressed: () => _singInWithEmail(userProvider),
                                                        child: Text(
                                                            'Entrar',
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                            ),
                                                        ),
                                                        color: Theme.of(context).primaryColor,
                                                        padding: EdgeInsets.symmetric(vertical: 15),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                                    ),
                                                ],
                                            ),
                                        ),
                                    ),
                                    if (_isKeyBoardOpen(context)) SizedBox(height: 15),
                                    if (!_isKeyBoardOpen(context)) Padding(
                                        padding: EdgeInsets.only(top: 15),
                                        child: OuDivider(),
                                    ),
                                    if (!_isKeyBoardOpen(context)) Padding(
                                        padding: EdgeInsets.only(bottom: 30),
                                        child: FlatButton(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                            onPressed: () => _singInWithGoogle(userProvider),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                    SvgPicture.asset(
                                                        'assets/images/google_icon.svg',
                                                        height: 30,
                                                        width: 30,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Text('Entrar com Google'),
                                                    ),
                                                ],
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: _height / 20),
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                    'Cadê\nÔnibus',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontSize: _isKeyBoardOpen(context) ? 45 : 70,
                                        color: Theme.of(context).primaryColor,
                                    ),
                                ),
                            ),
                        ),
                        if (_isLoading) Container(
                            color: Theme.of(context).primaryColor.withOpacity(0.8),
                            child: Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    TextFormField _buildEmailField() =>
        TextFormField(
            onSaved: (value) => _email = value,
            keyboardType: TextInputType.emailAddress,
            validator: _emailFormValidation,
            decoration: InputDecoration(
                labelText: 'E-mail',
                hasFloatingPlaceholder: false,
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Theme.of(context).errorColor,
                        width: 3,
                    ),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 3,
                    )
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Icon(
                    Icons.email,
                    color: _getEmailIconColor,
                ),
            ),
        );

    TextFormField _buildPasswordField() =>
        TextFormField(
            onSaved: (value) => _password = value,
            obscureText: !_showPassword,
            validator: _passwordFormValidation,
            decoration: InputDecoration(
                labelText: 'Senha',
                hasFloatingPlaceholder: false,
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Theme.of(context).errorColor,
                        width: 3,
                    ),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 3,
                    )
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                    icon: Icon(
                        _gePasswordIcon,
                        color: _getPasswordIconColor,
                    ),
                    onPressed: () => setState(() => _showPassword = !_showPassword),
                ),
            ),
        );

    IconData get _gePasswordIcon {
        if (_showPassword) return FontAwesomeIcons.eye;
        return FontAwesomeIcons.eyeSlash;
    }

    Color get _getEmailIconColor {
        if (_hasEmailFormError) return Colors.red;
        return null;
    }

    Color get _getPasswordIconColor {
        if (_hasPasswordFormError) return Colors.red;
        return null;
    }

    String _emailFormValidation(String value) {
        final defaultVal = Validations.defaultValidator(value, 2);
        if (defaultVal != null) {
            setState(() => _setEmailFormErro = true);
            return defaultVal;
        }

        final email = Validations.isEmailValid(input: value);
        if (email != null) {
            setState(() => _setEmailFormErro = true);
            return email;
        }

        setState(() => _setEmailFormErro = false);
        return null;

    }

    String _passwordFormValidation(String value) {
        final required = Validations.defaultValidator(value, 3);
        if (required != null) {
            _setPasswordFormErro = true;
            return required;
        }

        _setPasswordFormErro = false;
        return null;

    }

    set _setPasswordFormErro(bool value) {
        setState(() => _hasPasswordFormError = value);
    }

    set _setEmailFormErro(bool value) {
        setState(() => _hasEmailFormError = value);
    }

    set _updateLoadingState(bool value) {
        setState(() {
            _isLoading = value;
            widget._isLoadingStream.add(value);
        });
    }

    bool _isKeyBoardOpen(BuildContext context) {
        if (MediaQuery.of(context).viewInsets.bottom == 0) return false;
        return true;
    }

    Future<void> _singInWithEmail(final UserProviders userProvider) async {
        if (!_formKey.currentState.validate()) return;
        _formKey.currentState.save();
        _updateLoadingState = true;
        try {
            if (!await _isInternetOn(context)) {
                _updateLoadingState = false;
                return;
            }
            final response = await AuthResource.loginWithEmail(_email, _password);
            await _singIn(response, userProvider);
        } on ResourceException catch(err) {
            ToastUtil.showToast(err.msg, context, color: ToastUtil.error);
        } catch(generic, stack) {
            print('StackTrace\n$stack');
            ToastUtil.showToast('Algo deu errado', context, color: ToastUtil.error);
        } finally {
            _updateLoadingState = false;
        }
    }

    Future<void> _singInWithGoogle(UserProviders userProvider) async {
        var googleResponse;
        try {
            googleResponse = await _googleSignIn.signIn();
            _updateLoadingState = true;
            final response = await AuthResource.loginWithGoogle(googleResponse.email, googleResponse.id);
            await _singIn(response, userProvider);
        } on ResourceException catch (err, stack) {
            if (err.msg == 'Usuário não encontrado') {
                print('Usuario n encontrado');
                await _createUserWithGoogle(googleResponse, userProvider);
            }
            Catcher.reportCheckedError(err, stack);
        } catch (err, stack) {
            print('Erro while attempt to singIn with Google');
            print('ERROR: \n$err');
            print('StackTrace: \t$stack');
            Catcher.reportCheckedError(err, stack);
            ToastUtil.showToast('Erro tentar fazer login com Google', context, color: ToastUtil.error);
        } finally {
            _updateLoadingState = false;
        }
    }

    Future<void> _singIn(final String response, final UserProviders userProvider, {final bool isNewUser = false}) async {
        final token = await JWTService.saveUser(response);
        final user = await UserProviders.findUser(token.payload.email);
        userProvider.setCurrentUser(user);

        final isDFTransOn = await CheckStatusService.isDFTransAvailable();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext ctx) => HomePage(isDFTransOn, isNewUser))
        );
    }

    Future<void> _createUserWithGoogle(GoogleSignInAccount account, UserProviders userProvider) async {
        try {
            final user = await UserResource.createUserWithGoogle(account);
            final response = await AuthResource.loginWithGoogle(user.email, user.googleId);
            await _singIn(response, userProvider, isNewUser: true);
        } on DioError catch(err, stack) {
            print('Request erro while creating user with Google');
            print('ERROR: \n$err');
            print('Response: \t${err.response}');
            print('StatusCode: \t${err.response.statusCode}');
            Catcher.reportCheckedError(err, stack);
            ToastUtil.showToast('Não foi possivel criar conta', context, color: ToastUtil.error);
            return null;
        } catch (generic, stack) {
            print('Error while creating user with Google');
            print('ERROR: \n$generic');
            print('StackTrace: \t$stack');
            Catcher.reportCheckedError(generic, stack);
            ToastUtil.showToast('Algo deu errado ao criar conta', context, color: ToastUtil.error);
            throw generic;
        }
    }

    Future<bool> _isInternetOn(BuildContext context) async {
        final isInternetOn = await CheckStatusService.isInternetAvailable();
        if (!isInternetOn) {
            ToastUtil.showToast('Sem conexão com a internet', context, color: ToastUtil.warning);
            return false;
        }
        return true;
    }
}
