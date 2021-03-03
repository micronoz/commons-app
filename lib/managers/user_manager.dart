import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tribal_instinct/model/is_logged_in.dart';

String getProfileQuery = '''
  query GetUserProfile {
    user {
      id
      handle
      fullName
    }
  }
''';

class UserManager {
  ValueNotifier<bool> absorbing = ValueNotifier(true);
  ValueNotifier<Map<String, AppUser>> profiles = ValueNotifier({});

  final appUser = ValueNotifier<AppUser>(null);
  final isLoggedIn = ValueNotifier<IsLoggedIn>(IsLoggedIn(false));

  User _firebaseUser;
  final _googleSignIn = GoogleSignIn();
  final _firebaseAuth = FirebaseAuth.instance;
  var _authSub;

  final ValueNotifier<Future<QueryResult>> appUserResolver;

  ValueNotifier<GraphQLClient> _graphQLClientNotifier;
  static Future<UserManager> create() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    try {
      await firebaseUser?.reload();
    } catch (err) {
      await FirebaseAuth.instance.signOut();
    }

    return UserManager._(firebaseUser);
  }

  static UserManager of(BuildContext context) {
    return Provider.of<UserManager>(context, listen: false);
  }

  void registerGraphQL(ValueNotifier<GraphQLClient> notifier) {
    print('Registering graphql notifier to userManager.');

    _graphQLClientNotifier = notifier;
  }

  Future<String> getIdToken() {
    return _firebaseUser.getIdToken();
  }

  Future<void> fetchUserProfile() async {
    if (_firebaseUser != null && _graphQLClientNotifier != null) {
      absorbing.value = true;
      print('Fetching user profile');
      appUserResolver.value = _graphQLClientNotifier.value.query(QueryOptions(
        document: gql(getProfileQuery),
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      var result = await appUserResolver.value;
      // TODO: Right now only checking if the data is null to see if the
      // user exists on the backend or not. This should be changed as this
      // might also be due to network or other errors.
      if (result.data == null) {
        print(result);
        print('User fetching returned null data.');
        appUser.value = null;
        return;
      }
      print('Fetched user result successfully:');
      final profileJSON = result.data['user'];
      appUser.value = AppUser.fromJson(profileJSON);
      absorbing.value = false;
    } else {
      appUser.value = null;
    }
  }

  UserManager._(User firebaseUser) : appUserResolver = ValueNotifier(null) {
    _firebaseUser = firebaseUser;
    isLoggedIn.value =
        firebaseUser == null ? IsLoggedIn(false) : IsLoggedIn(true);
    _authSub = _firebaseAuth.idTokenChanges().listen((User user) {
      _firebaseUser = user;
      isLoggedIn.value = user == null ? IsLoggedIn(false) : IsLoggedIn(true);
      fetchUserProfile();
    });
  }

  void dispose() {
    _authSub.cancel();
  }

  Future<void> loginAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } catch (e, st) {
      throw _getAuthException(e, st);
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e, st) {
      throw _getAuthException(e, st);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        throw AuthException.cancelled;
      }
      final auth = await account.authentication;
      await _firebaseAuth.signInWithCredential(
        GoogleAuthProvider.credential(
            idToken: auth.idToken, accessToken: auth.accessToken),
      );
    } catch (e, st) {
      throw _getAuthException(e, st);
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e, st) {
      FlutterError.reportError(FlutterErrorDetails(exception: e, stack: st));
    }
  }

  AuthException _getAuthException(dynamic e, StackTrace st) {
    if (e is AuthException) {
      return e;
    }
    FlutterError.reportError(FlutterErrorDetails(exception: e, stack: st));
    if (e is PlatformException) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          return const AuthException('Please check your email address.');
        case 'ERROR_WRONG_PASSWORD':
          return const AuthException('Please check your password.');
        case 'ERROR_USER_NOT_FOUND':
          return const AuthException(
              'User not found. Is that the correct email address?');
        case 'ERROR_USER_DISABLED':
          return const AuthException(
              'Your account has been disabled. Please contact support');
        case 'ERROR_TOO_MANY_REQUESTS':
          return const AuthException(
              'You have tried to login too many times. Please try again later.');
      }
    }
    return const AuthException('Sorry, an error occurred. Please try again.');
  }
}

class AuthException implements Exception {
  static const cancelled = AuthException('cancelled');
  const AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}
