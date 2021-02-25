import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/model/user_profile.dart';

class UserManager {
  ValueNotifier<bool> absorbing = ValueNotifier(true);
  ValueNotifier<Map<String, AppUser>> profiles = ValueNotifier({});

  static UserManager create() {
    // return UserManager._(null);
    final myUser = AppUser.mock();
    return UserManager._(myUser);
  }

  Future<void> init() async {
    absorbing.value = true;
    print('Requesting user object');
    var user = await _fetchUserProfile();
    currentUser.value = user;
    absorbing.value = false;
  }

  static UserManager of(BuildContext context) {
    return Provider.of<UserManager>(context, listen: false);
  }

  Future<AppUser> _fetchUserProfile() async {
    // return AppUser.fromJson({'id': '1'});
    return AppUser.mock();
  }

  UserManager._(
    AppUser currentUser,
  ) : currentUser = ValueNotifier<AppUser>(currentUser);

  final ValueNotifier<AppUser> currentUser;
}
