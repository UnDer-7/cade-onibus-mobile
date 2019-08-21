import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../resources/users_resource.dart';
import '../resources/auth_resource.dart';
import '../resources/resource_exception.dart';

import '../services/jwt_service.dart';
import '../services/check_status_service.dart';
import '../services/service_exception.dart';

import '../utils/validations.dart';
import '../utils/toast_util.dart';

import '../pages/home_page.dart';
import '../widgets/ou_divider.dart';
import '../providers/user_provider.dart';


class NewAccountPage extends StatefulWidget {
    @override
    _NewAccountPageState createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
    final GlobalKey<FormState> _formKey = GlobalKey();
    bool _isLoading = false;

    String _password;
    String _email;
    String _name;
    bool _showPassword = false;
    bool _hasEmailFormError = false;
    bool _hasPasswordFormError = false;
    bool _hasNameFormError = false;

    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        final UserProviders _userProvider = Provider.of<UserProviders>(context);
        final double _keyboardOpen = MediaQuery.of(context).viewInsets.bottom;

        return Scaffold(
            resizeToAvoidBottomInset: false,
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
                    Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                                'Nova Conta',
                                style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 30,
                                    color: Colors.white,
                                ),
                            ),
                        ),
                    ),
                    SvgPicture.asset(
                        'assets/images/bus_stop_backgroud.svg',
                        semanticsLabel: 'background',
                    ),
                    Positioned(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        left: 0,
                        right: 0,
                        child: Form(
                            key: _formKey,
                            child: Padding(
                                padding: EdgeInsets.only(bottom: _getFormPaddingButton(_keyboardOpen), left: 20, right: 20),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
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
                                        ),
                                        SizedBox(height: 10),
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
                                    ],
                                ),
                            ),
                        ),
                    ),
                    Container(
                        padding: EdgeInsets.only(bottom: 90, left: 20, right: 20),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: _buildSubmitButton(_userProvider),
                        ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: OuDivider(),
                        ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: _buildGoogleButton(_userProvider),
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

    Widget _buildGoogleButton(UserProviders userProvider) =>
        Padding(
            padding: EdgeInsets.only(bottom: 15, left: 20, right: 20),
            child: RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//                onPressed: () => _loginWithGoogle(userProvider),
                onPressed: () => {},
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
                            child: Text('Cria conta usando Google'),
                        ),
                    ],
                ),
            ),
        );

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

    double _getFormPaddingButton(double isOpen) {
        if (isOpen == 0) return 150;
        return 10;
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


    SizedBox _buildSubmitButton(UserProviders userProviders) =>
        SizedBox(
            width: double.maxFinite,
            child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Theme.of(context).primaryColor,
                onPressed: () => _submit(userProviders),
                child: Text(
                    'Criar Conta',
                    style: TextStyle(
                        color: Colors.white,
                    ),
                ),
            ),
        );

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

    Future<void> _singIn(final String response, final UserProviders userProvider) async {
        final token = await JWTService.saveUser(response);
        final user = await UserProviders.findUser(token.payload.email);
        userProvider.setCurrentUser(user);

        final isDFTransOn = await CheckStatusService.isDFTransAvailable();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext ctx) => HomePage(isDFTransOn, true),
            ),
        );
    }
}
