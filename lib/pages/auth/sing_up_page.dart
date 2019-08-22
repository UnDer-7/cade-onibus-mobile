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

class SingUpPage extends StatefulWidget {
    final PageController _pageController;

    SingUpPage(this._pageController);

    @override
    _SingUpPageState createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
    final GlobalKey<FormState> _formKey = GlobalKey();
    bool _isLoading = false;

    String _password;
    String _email;
    String _name;
    bool _showPassword = false;
    bool _hasEmailFormError = false;
    bool _hasPasswordFormError = false;
    bool _hasNameFormError = false;

    final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
            'email',
            'https://www.googleapis.com/auth/contacts.readonly',
        ],
    );

    @override
    WillPopScope build(BuildContext context) {
        final UserProviders userProvider = Provider.of<UserProviders>(context, listen: false);
        final double _height = MediaQuery.of(context).size.height;

        return WillPopScope(
            onWillPop: () {
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
                                                  _buildNameField(),
                                                  SizedBox(height: 15),
                                                  _buildEmailField(),
                                                  SizedBox(height: 15),
                                                  _buildPasswordField(),
                                                  SizedBox(height: 20),
                                                  RaisedButton(
                                                      onPressed: () => _submit(userProvider),
                                                      child: Text(
                                                          'Criar Conta',
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
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: FlatButton(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          onPressed: () => _createUserWithGoogle(userProvider),
//                                        onPressed: () => _singInWithGoogle(userProvider),
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
                                                      child: Text('Criar conta com Google'),
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

    TextFormField _buildNameField() =>
        TextFormField(
            onSaved: (value) => _name = value,
            keyboardType: TextInputType.text,
            validator: _nameFormValidation,
            decoration: InputDecoration(
                labelText: 'Nome',
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
                    Icons.person,
                    color: _getNameIconColor,
                ),
            ),
        );

    TextFormField _buildEmailField() =>
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
        );

    TextFormField _buildPasswordField() =>
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
        );

    bool _isKeyBoardOpen(BuildContext context) {
        if (MediaQuery.of(context).viewInsets.bottom == 0) return false;
        return true;
    }

    IconData get _gePasswordIcon {
        if (_showPassword) return FontAwesomeIcons.eye;
        return FontAwesomeIcons.eyeSlash;
    }

    Color get _getNameIconColor {
        if (_hasNameFormError) return Colors.red;
        return null;
    }

    Color get _getEmailIconColor {
        if (_hasEmailFormError) return Colors.red;
        return null;
    }

    Color get _getPasswordIconColor {
        if (_hasPasswordFormError) return Colors.red;
        return null;
    }

    String _nameFormValidation(String value) {
        final required = Validations.defaultValidator(value, 3);
        if (required != null) {
            _setNameFormErro = true;
            return required;
        }

        _setNameFormErro = false;
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

    set _setNameFormErro(bool value) =>
        setState(() => _hasNameFormError = value);

    set _setPasswordFormErro(bool value) =>
        setState(() => _hasPasswordFormError = value);


    set _setEmailFormErro(bool value) =>
        setState(() => _hasEmailFormError = value);

    Future<void> _submit(UserProviders userProvider) async {
        if (!_formKey.currentState.validate()) return;
        _formKey.currentState.save();

        setState(() => _isLoading = true);

        try {
            await UserResource.createUserWithEmail(_email, _password, _name);
            final response = await AuthResource.loginWithEmail(_email, _password);
            await _singIn(response, userProvider);
        } on ResourceException catch(err) {
            ToastUtil.showToast(err.msg, context, color: ToastUtil.error);
        } catch(generic, stack) {
            print('Erro ao criar usuario com email/senha');
            print('ERRO: \n$generic');
            print('StackTrace: $stack');
            ToastUtil.showToast('Algo deu errado ao criar usuário', context, color: ToastUtil.error);
        } finally {
            setState(() => _isLoading = false);
        }
    }
    Future<void> _createUserWithGoogle(UserProviders userProvider) async {
        GoogleSignInAccount googleResponse;
        try {
            googleResponse = await _googleSignIn.signIn();
            setState(() => _isLoading = true);
            final user = await UserResource.createUserWithGoogle(googleResponse);
            final response = await AuthResource.loginWithGoogle(user.email, user.googleId);
            await _singIn(response, userProvider);
        } on DioError catch(err) {
            if (err.response.toString() == 'resource-already-exists' && err.response.statusCode == 400) {
                final response = await AuthResource.loginWithGoogle(googleResponse.email, googleResponse.id);
                await _singIn(response, userProvider, isNewUser: false);
                return null;
            }
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
        } finally {
            setState(() => _isLoading = false);
        }
    }

    Future<void> _singIn(final String response, final UserProviders userProvider, {final bool isNewUser = true}) async {
        final token = await JWTService.saveUser(response);
        final user = await UserProviders.findUser(token.payload.email);
        userProvider.setCurrentUser(user);

        final isDFTransOn = await CheckStatusService.isDFTransAvailable();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext ctx) => HomePage(isDFTransOn, isNewUser),
            ),
        );
    }
}
