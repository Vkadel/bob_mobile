import 'package:bob_mobile/modelData/provider.dart';
import 'package:bob_mobile/helpers/validators.dart';
import 'package:bob_mobile/widgets/email_signin_button.dart';
import 'package:bob_mobile/widgets/google_signin_button.dart';
import 'package:bob_mobile/widgets/rounded_edge_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bob_mobile/widgets/scrollable_widget_window.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  FormType _formtype = FormType.login;
  String _email, _password;
  Text _tittle_register = new Text('Register to Battle');
  Text _tittle_login = new Text('Log in Champion');

  @override
  Widget build(BuildContext context) {
    print('Building ');
    return Scaffold(
      appBar: AppBar(
        title: _tittle_login,
      ),
      body: Form(
        key: formKey,
        child: Center(
            child: myScrollableWindow(
          context,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: buildLogoTitle() + buildInputs() + buildButtons(),
          ),
        )),
      ),
    );
  }

  bool validate() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  //After user entered information is validated the user can submit

  void submit() async {
    if (validate()) {
      final auth = FireProvider.of(context).auth;
      try {
        if (_formtype == FormType.login) {
          String userid =
              await auth.signInWithEmailAndPassword(_email.trim(), _password);
          print('signed in $userid');
          if (userid != null) {}
        } else {
          String userid = await auth.createUserWithEmailAndPassword(
              _email.trim(), _password);
          print('Registered in $userid');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void switchFormState(FormType state) {
    print('Switching state to: $state');
    formKey.currentState.reset();
    if (state == FormType.login) {
      setState(() {
        print('Switching state to: register');
        _formtype = FormType.register;
      });
    } else {
      setState(() {
        _formtype = FormType.login;
      });
    }
  }

  List<Widget> buildInputs() {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: TextFormField(
          validator: EmailValidator.validate,
          decoration: InputDecoration(labelText: 'email'),
          onSaved: (value) => _email = value,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: TextFormField(
          validator: PasswordValidator.validate,
          decoration: InputDecoration(labelText: 'password'),
          obscureText: true,
          onSaved: (value) => _password = value,
        ),
      ),
    ];
  }

  List<Widget> buildButtons() {
    //Login
    if (_formtype == FormType.login) {
      return [
        //TODO: String
        EmailSignInButton('Login with email', submit, context),
        //TODO: String
        GoogleSingInButton('Log in with Google', FireProvider.of(context).auth),
        FlatButton(
          onPressed: () {
            switchFormState(_formtype);
          },
          //TODO: String
          child: Text('Go to Register Account'),
        ),
        FlatButton(
          onPressed: () {
            FireProvider.of(context).auth.passwordReset(_email);
          },
          //TODO: String
          child: Text('Forgot my Password'),
        ),
      ];
    } else {
      //Register
      return [
        //TODO: String
        EmailSignInButton('Register with email', submit, context),
        //TODO: String
        GoogleSingInButton(
            'Register with your Google Account', FireProvider.of(context).auth),
        FlatButton(
          //TODO: String
          child: Text('Go to Login'),
          onPressed: () {
            switchFormState(_formtype);
          },
        ),
      ];
    }
  }

  List<Widget> buildLogoTitle() {
    return [
      Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Battle of the Books',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w200),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1),
            child: Image(
              image: AssetImage('assets/bob_logo.png'),
              width: 200,
              height: 200,
            ),
          )
        ],
      ),
    ];
  }
}
