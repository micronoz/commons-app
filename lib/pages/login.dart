import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:tribal_instinct/managers/user_manager.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _onLoginWithGooglePressed() {
    UserManager.of(context).loginWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: FutureBuilder(
          future: UserManager.of(context).appUserResolver.value,
          builder: (context, state) {
            if (state.connectionState != ConnectionState.done &&
                state.connectionState != ConnectionState.none) {
              return Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignInButton(
                    Buttons.GoogleDark,
                    padding: EdgeInsets.only(left: 15, top: 3, bottom: 3),
                    onPressed: _onLoginWithGooglePressed,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40))),
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
