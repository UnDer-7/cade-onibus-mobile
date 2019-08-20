import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../resources/auth_resource.dart';
import '../resources/resource_exception.dart';
import '../resources/users_resource.dart';

import '../utils/toast_util.dart';
import '../utils/validations.dart';

import '../services/jwt_service.dart';
import '../services/check_status_service.dart';

import '../providers/user_provider.dart';
import '../pages/home_page.dart';

class AuthPage extends StatefulWidget {
    @override
    _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
    final GlobalKey<FormState> _formKey = GlobalKey();

    String _password;
    String _email;
    bool _isLoading = false;
    bool _showPassword = false;
    bool _hasEmailFormError = false;
    bool _hasPasswordFormError = false;

    final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
            'email',
            'https://www.googleapis.com/auth/contacts.readonly',
        ],
    );

    @override
    Widget build(BuildContext context) {
        final double _width = MediaQuery.of(context).size.width;
        final double _height = MediaQuery.of(context).size.height;
        final UserProviders userProviders = Provider.of<UserProviders>(context);

        return Scaffold(
            body: Stack(
                children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                end: Alignment.bottomLeft,
                                begin: Alignment.topRight,
                                colors: [
                                    Color(4285547775),
                                    Colors.pink,
                                ]
                            )
                        ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                                'Cadê Ônibus',
                                style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 40,
                                    color: Colors.white,
                                ),
                            ),
                        ),
                    ),
                    SvgPicture.asset(
                        'assets/images/bus_stop_backgroud.svg',
                        semanticsLabel: 'background',
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: SingleChildScrollView(
                            child: Container(
                                margin: EdgeInsets.only(bottom: 90),
                                width: _width / 1.3,
                                height: _height / 2.3,
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Form(
                                        key: _formKey,
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                                TextFormField(
                                                    onSaved: (value) => _email = value,
                                                    keyboardType: TextInputType.emailAddress,
                                                    validator: _emailFormValidation,
                                                    decoration: InputDecoration(
                                                        labelText: 'E-mail',
                                                        hasFloatingPlaceholder: false,
                                                        errorStyle: TextStyle(
                                                            color: Colors.white,
                                                        ),
                                                        errorBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                            borderSide: BorderSide(
                                                                color: Theme.of(context).errorColor,
                                                                width: 3,
                                                            ),                                                        ),
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
                                                ),
                                                SizedBox(height: 10),
                                                TextFormField(
                                                    onSaved: (value) => _password = value,
                                                    obscureText: !_showPassword,
                                                    validator: _passwordFormValidation,
                                                    decoration: InputDecoration(
                                                        labelText: 'Senha',
                                                        hasFloatingPlaceholder: false,
                                                        errorStyle: TextStyle(
                                                            color: Colors.white,
                                                        ),
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
                                                ),
                                                SizedBox(height: 15),
                                                _buildEntrarButton(userProviders),
                                                _buildDivider(),
                                                _buildGoogleButton(userProviders),
                                            ],
                                        ),
                                    ),
                                ),
                            ),
                        ),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 50),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: _buildNewUserButton(),
                        ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.only(bottom: 10),
                            width: double.infinity,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                elevation: 5,
                                color: Colors.white,
                                onPressed: () {},
                                child: Text(
                                    'Só quero procurar um ônibus',
                                    style: TextStyle(
                                        color: Colors.pink,
                                    ),
                                ),
                            ),
                        ),
                    ),
                    if (_isLoading) Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.5),
                        ),
                    ),
                    if (_isLoading) Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        ),
                    ),
                ],
            ),
        );
    }

    RaisedButton _buildEntrarButton(UserProviders userProviders) =>
        RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: Theme.of(context).primaryColor,
            onPressed: () => _loginWithEmail(userProviders),
            child: Text(
                'Entrar',
                style: TextStyle(
                    color: Colors.white,
                ),
            ),
        );

    Row _buildDivider() =>
        Row(
            children: <Widget>[
                Expanded(
                    child: Divider(
                        color: Theme.of(context).primaryColor,
                        height: 30,
                    )
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Ou"),
                ),
                Expanded(
                    child: Divider(
                        color: Theme.of(context).primaryColor,
                    )
                ),
            ]
        );

    Widget _buildGoogleButton(UserProviders userProvider) =>
        Padding(
            padding: EdgeInsets.only(top: 5),
            child: OutlineButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                borderSide: BorderSide(
                    width: 1,
                    color: Theme.of(context).primaryColor,
                ),
                onPressed: () => _loginWithGoogle(userProvider),
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
        );

    Row _buildNewUserButton() =>
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Text(
                    'Novo usuario?',
                    style: TextStyle(
                        color: Colors.white,
                    ),
                ),
                FlatButton(
                    onPressed: () {},
                    child: Text(
                        'Criar Conta',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                        ),
                    ),
                ),
            ],
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

    Future<void> _loginWithGoogle(UserProviders userProvider) async {
        var googleResponse;
        try {
            googleResponse = await _googleSignIn.signIn();
            setState(() => _isLoading = true);
            final response = await AuthResource.loginWithGoogle(googleResponse.email, googleResponse.id);
            await _singIn(response, userProvider);
        } on ResourceException catch (err) {
            if (err.msg == 'Usuário não encontrado') {
                print('Usuario n encontrado');
                await _createUserWithGoogle(googleResponse, userProvider);
            }
        } catch (err, stack) {
            print('Erro while attempt to singIn with Google');
            print('ERROR: \n$err');
            print('StackTrace: \t$stack');
            ToastUtil.showToast('Erro tentar fazer login com Google', context, color: ToastUtil.error);
        } finally {
            setState(() => _isLoading = false);
        }
    }

    Future<void> _loginWithEmail(UserProviders userProvider) async {
        if (!_formKey.currentState.validate()) return;
        _formKey.currentState.save();
        setState(() => _isLoading = true);
        try {
            if (!await _isInternetOn(context)) {
                setState(() => _isLoading = false);
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
            setState(() => _isLoading = false);
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
        } on DioError catch(err) {
            print('Request erro while creating user with Google');
            print('ERROR: \n$err');
            print('Response: \t${err.response}');
            print('StatusCode: \t${err.response.statusCode}');
            ToastUtil.showToast('Não foi possivel criar conta', context, color: ToastUtil.error);
            return null;
        } catch (generic, stack) {
            print('Error while creating user with Google');
            print('ERROR: \n$generic');
            print('StackTrace: \t$stack');
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
