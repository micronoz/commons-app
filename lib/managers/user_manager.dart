import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tribal_instinct/model/app_user.dart';

class UserManager {
  ValueNotifier<bool> absorbing = new ValueNotifier(true);
  ValueNotifier<Map<String, AppUser>> profiles = new ValueNotifier(new Map());

  static UserManager create() {
    return UserManager._(null);
  }

  Future<void> init() async {
    absorbing.value = true;
    print('Requesting user object');
    AppUser user = await _getUserProfile();
    currentUser.value = user;
    absorbing.value = false;
  }

  static UserManager of(BuildContext context) {
    return Provider.of<UserManager>(context, listen: false);
  }

  UserManager._(
    AppUser currentUser,
  ) : this.currentUser = ValueNotifier<AppUser>(currentUser);

  final ValueNotifier<AppUser> currentUser;
}
