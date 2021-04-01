import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tribal_instinct/managers/user_manager.dart';
import 'package:tribal_instinct/model/user_profile.dart';

final updateUserMutation = r'''
  mutation UpdateUser($firstName: String!, $lastName: String!, $bio: String!) {
    updateUser(firstName: $firstName, lastName: $lastName, bio: $bio) {
      id
      firstName
      lastName
      handle
      fullName
      bio
    }
  }
''';

class EditProfilePage extends StatefulWidget {
  UserProfile profile = UserProfile.mock();
  EditProfilePage() : super();
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _firstName;
  String _lastName;
  String _bio;
  bool _isBottomSheetOpen = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const maxInputSize = 255;
  static const emptyFieldError = 'You can not leave this field empty.';
  static const largeInputError =
      'This field can not have more than than ${maxInputSize} characters.';

  String _mandatoryValidator(String value) {
    if (value == null || value.isEmpty) {
      return emptyFieldError;
    } else if (value.length > maxInputSize) {
      return largeInputError;
    } else {
      return null;
    }
  }

  String _genericValidator(String value) {
    if (value.length > maxInputSize) {
      return largeInputError;
    } else {
      return null;
    }
  }

  Future<bool> saveAndExit(
      BuildContext context, RunMutation updateUserMutation) async {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    final result = await updateUserMutation(
            {'firstName': _firstName, 'lastName': _lastName, 'bio': _bio})
        .networkResult;
    print(result);
    if (result.hasException) {
      showCustomBottomSheet('An Error has occurred');
      return false;
    } else {
      await UserManager.of(context).fetchUserProfile();
      showCustomBottomSheet('Successfully saved!');
      return true;
    }
  }

  void showCustomBottomSheet(String message) {
    if (_isBottomSheetOpen) return;
    _isBottomSheetOpen = true;
    final sheet = _scaffoldKey.currentState
        .showBottomSheet<void>((context) => BottomSheet(
            key: UniqueKey(),
            onClosing: () {
              if (mounted) _isBottomSheetOpen = false;
            },
            builder: (context) => Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  color: Colors.blueGrey[100],
                  child: Center(
                    child: Text(
                      message,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                )));

    Timer(Duration(seconds: 1, milliseconds: 500), () => sheet.close());
  }

  @override
  Widget build(BuildContext context) {
    final formTextStyle =
        Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16);
    return Mutation(
      options: MutationOptions(document: gql(updateUserMutation)),
      builder: (RunMutation runMutation, QueryResult result) => GestureDetector(
        onTap: () {
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: false,
            title: Text('Edit Profile'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: ListView(
                      children: [
                        TextFormField(
                            decoration: InputDecoration(hintText: 'First Name'),
                            onSaved: (value) =>
                                setState(() => _firstName = value),
                            validator: _mandatoryValidator,
                            initialValue: widget.profile.firstName,
                            style: formTextStyle),
                        TextFormField(
                            decoration: InputDecoration(hintText: 'Last Name'),
                            onSaved: (value) =>
                                setState(() => _lastName = value),
                            validator: _mandatoryValidator,
                            initialValue: widget.profile.lastName,
                            style: formTextStyle),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Add a bio'),
                          onSaved: (value) => setState(() => _bio = value),
                          validator: _genericValidator,
                          maxLines: null,
                          initialValue: widget.profile.bio,
                          style: formTextStyle,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () async {
                      _formKey.currentState.save();
                      await saveAndExit(context, runMutation);
                    },
                    icon: Icon(FontAwesome5.check),
                    label: Text('Save'),
                  ),
                  const SizedBox(
                    height: 35,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
