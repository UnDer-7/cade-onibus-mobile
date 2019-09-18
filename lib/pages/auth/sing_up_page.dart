import 'dart:async';

import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    final StreamController<bool> _isLoadingStream;

    SingUpPage(this._pageController, this._isLoadingStream);

    @override
    _SingUpPageState createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
    final GlobalKey<FormState> _formKey = GlobalKey();
    final GlobalKey<FormState> _formKeyAssociated = GlobalKey();
    bool _isLoading = false;

    String _password;
    String _passwordAssociate;
    String _email;
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
                    curve: Curves.fastOutSlowIn,
                );
                return Future.value(false);
            },
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.white,
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

    Color get _getEmailIconColor {
        if (_hasEmailFormError) return Colors.red;
        return null;
    }

    Color get _getPasswordIconColor {
        if (_hasPasswordFormError) return Colors.red;
        return null;
    }

    set _updateLoadingState(bool value) {
        setState(() {
            _isLoading = value;
            widget._isLoadingStream.add(value);
        });
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

    set _setPasswordFormErro(bool value) =>
        setState(() => _hasPasswordFormError = value);


    set _setEmailFormErro(bool value) =>
        setState(() => _hasEmailFormError = value);

    Future<void> _submit(UserProviders userProvider) async {
        if (!_formKey.currentState.validate()) return;
        if (!await _isInternetOn(context)) {
            _updateLoadingState = false;
            return;
        }
        _formKey.currentState.save();
        _updateLoadingState = true;

        try {
            await UserResource.createUserWithEmail(_email, _password);
            final response = await AuthResource.loginWithEmail(_email, _password);
            await _singIn(response, userProvider);
        } on ResourceException catch(err) {
            if (err.msg == 'can-crate') {
                final res = await _loadDialog();
                if (res != null && res) {
                    await _associateAccounts(userProvider);
                }
                return;
            }
            ToastUtil.showToast(err.msg, context, color: ToastUtil.error);
        } catch(generic, stack) {
            print('Erro ao criar usuario com email/senha');
            print('ERRO: \n$generic');
            print('StackTrace: $stack');
            Catcher.reportCheckedError(generic, stack);
            ToastUtil.showToast('Algo deu errado ao criar usuário', context, color: ToastUtil.error);
        } finally {
            _updateLoadingState = false;
        }
    }

    Future<bool> _loadDialog() async {
        final answer = await showDialog(
            context: context,
            builder: (BuildContext ctx) =>
                AlertDialog(
                    title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Text(
                                'E-mail já foi cadastrado',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20
                                ),
                            ),
                            Text(
                                _email,
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                ),
                            ),
                        ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    content: Container(
                        height: 200,
                        width: 500,
                        child: Column(
                            children: <Widget>[
                                Text('Você pode entrar usando sua conta do Google.'),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: OuDivider(),
                                ),
                                Text('Você pode associar essa senha com o E-mail cadastrado e entrar com ela. Você ainda podera entrar utilizando o Google'),
                            ],
                        ),
                    ),
                    actions: <Widget>[
                        FlatButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(
                                'Entrar usando Google',
                                style: TextStyle(
                                    color: Colors.green,
                                ),
                            ),
                        ),
                        FlatButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text('Associar senha'),
                        ),
                    ],
                ),
        );
        return Future.value(answer);
    }

    Future<void> _successAssociateDialog(UserProviders userProvider, {email, password}) async {
        showDialog(
            context: context,
            builder: (BuildContext ctx) =>
                AlertDialog(
                    title: Text(
                        'Senha associada com sucesso',
                        style: TextStyle(
                            color: Colors.green,
                        ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    content: Text('Sua senha foi associada com a conta do Google.\n'
                        'Agora você pode entrar no Cadê Ônibus usando o Google ou com o email e senha!'),
                    actions: <Widget>[
                        FlatButton(
                            onPressed: () async {
                                final savedEmail = email == null ? _email : email;
                                final savedPassword = password == null ? _password : password;
                                final response = await AuthResource.loginWithEmail(savedEmail, savedPassword);
                                Navigator.pop(ctx);
                                await _singIn(response, userProvider, isNewUser: false);
                            },
                            child: Text('Entrar no Cadê Ônibus'),
                        ),
                    ],
                ),
        );
    }

    Future<void> _associateAccounts(UserProviders userProvider) async {
        try {
            final googleResponse = await _googleSignIn.signIn();
            if (googleResponse == null) return;

            print('GOOGLE -> ${googleResponse.email}');
            print('TYPED -> $_email');
            if (googleResponse.email != _email) {
                ToastUtil.showToast('E-mail informado é diferente da conta do Google', context, color: ToastUtil.error, duration: 6);
                return;
            }

            await UserResource.associateAccounts(googleResponse, _password);
            await _successAssociateDialog(userProvider);
        } on ResourceException catch (err) {
            ToastUtil.showToast(err.msg, context, color: ToastUtil.error);
        } catch (err, stack) {
            ToastUtil.showToast('Nao foi possivel associar conta\nAlgo deu errado', context, color: ToastUtil.error);
            Catcher.reportCheckedError(err, stack);
        }
    }

    Future<void> _createUserWithGoogle(UserProviders userProvider) async {
        GoogleSignInAccount googleResponse;
        try {
            if (!await _isInternetOn(context)) {
                _updateLoadingState = false;
                return null;
            }
            googleResponse = await _googleSignIn.signIn();
            if (googleResponse == null) return null;
            _updateLoadingState = true;
            final user = await UserResource.createUserWithGoogle(googleResponse);
            final response = await AuthResource.loginWithGoogle(user.email, user.googleId);
            await _singIn(response, userProvider);
        }  on ResourceException catch(err) {
            if (err.msg == 'can-crate') {
                await _associateEmailPasswordGoogleDialog(googleResponse, userProvider);
                return null;
            }

            ToastUtil.showToast(err.msg, context, color: ToastUtil.error);
        } finally {
            _updateLoadingState = false;
        }
    }

    Future<void> _associateEmailPasswordGoogleDialog(GoogleSignInAccount google, UserProviders userProvider) async {
        showDialog(
            context: context,
            builder: (BuildContext ctx) =>
                AlertDialog(
                    title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Text(
                                'E-mail já foi cadastrado',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20
                                ),
                            ),
                            Text(
                                google.email,
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                ),
                            ),
                        ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    content: Container(
                        height: 365,
                        width: 500,
                        child: ListView(
                            children: <Widget>[
                                Text('O E-mail informado pelo Google já foi cadastrado.'),
                                Text('Você pode entrar usando sua conta do Google'),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: OuDivider(),
                                ),
                                Text('Você pode associar o email cadastrado com essa conta do Google.'),
                                Text('Fazendo a associação você pode entrar utilizado o Google ou email e senha.'),
                                Text('Basta informar a senha que você utilizou no cadastro do email "${google.email}"'),
                                Form(
                                    key: _formKeyAssociated,
                                    child: TextFormField(
                                        onSaved: (value) => _passwordAssociate = value,
                                        validator: (value) => Validations.defaultValidator(value, 3),
                                        obscureText: true,
                                        decoration: InputDecoration(
                                            labelText: 'Senha',
                                        ),
                                    ),
                                ),
                            ],
                        ),
                    ),
                    actions: <Widget>[
                        FlatButton(
                            onPressed: () {},
                            child: Text(
                                'Entrar usando Google',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                ),
                            ),
                        ),
                        FlatButton(
                            onPressed: () async {
                                if (!_formKeyAssociated.currentState.validate()) return;
                                _formKeyAssociated.currentState.save();
                                try {
                                    await UserResource.associateEmailPasswordWithGoogle(google, _passwordAssociate);
                                    Navigator.pop(ctx);
                                    _successAssociateDialog(userProvider, email: google.email, password: _passwordAssociate);
                                } on ResourceException catch(err) {
                                    ToastUtil.showToast(err.msg, context, color: ToastUtil.error);
                                }
                            },
                            child: Text(
                                'Associar conta',
                                style: TextStyle(
                                    color: Colors.green,
                                ),
                            ),
                        ),
                    ],
                ),
        );
    }

    Future<void> _singIn(final String response, final UserProviders userProvider, {final bool isNewUser = true}) async {
        final token = await JWTService.saveUser(response);
        final user = await UserProviders.findUser(token.payload.email);
        userProvider.setCurrentUser(user);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext ctx) => HomePage(isNewUser),
            ),
        );
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
