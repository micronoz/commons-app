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
  void _onLoginWithGooglePressed() {
    setState(() {
      UserManager.of(context).loginWithGoogle();
    });
  }

  void _onLoginAnonymouslyPressed() {
    setState(() {
      UserManager.of(context).loginAnonymously();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: FutureBuilder(
          future: UserManager.of(context).appUserResolver.value,
          builder: (context, state) {
            if (state.connectionState == ConnectionState.waiting) {
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
