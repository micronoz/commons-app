import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:tribal_instinct/managers/user_manager.dart';

class LoginPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => LoginPage(),
    );
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future _loginFuture;

  void _onLoginWithGooglePressed() {
    setState(() {
      _loginFuture = UserManager.of(context).loginWithGoogle();
    });
  }

  void _onLoginAnonymouslyPressed() {
    setState(() {
      _loginFuture = UserManager.of(context).loginAnonymously();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: FutureBuilder(
          future: _loginFuture,
          builder: (context, state) {
            if (state.connectionState == ConnectionState.waiting ||
                state.connectionState == ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignInButton(
                    Buttons.Google,
                    onPressed: _onLoginWithGooglePressed,
                  ),
                  SignInButton(
                    Buttons.Email,
                    onPressed: _onLoginAnonymouslyPressed,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
