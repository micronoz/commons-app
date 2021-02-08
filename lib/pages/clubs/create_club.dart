import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateClubPage extends StatefulWidget {
  @override
  _CreateClubPageState createState() => _CreateClubPageState();
}

class _CreateClubPageState extends State<CreateClubPage> {
  final formSpacing = const SizedBox(
    height: 20,
  );

  String tribeName;
  String tribeSubtitle;
  String tribeSummary;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  PickedFile _pickedImage;

  Future<bool> exitDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure you want to cancel?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              print('Club creation succeess');
              _formKey.currentState.save();
            }
          },
          child: Icon(Icons.check),
        ),
        appBar: AppBar(
          title: Text('Establish a Club'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Text(
                  'Name your Club',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                TextFormField(
                  initialValue: tribeName,
                  validator: (value) => value.isEmpty ? '*Required' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (newValue) =>
                      tribeName = newValue, //TODO Check if name available
                ),
                formSpacing,
                Text(
                  'Describe your Club',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                TextFormField(
                  initialValue: tribeSummary,
                  onSaved: (newValue) => tribeSummary = newValue,
                  validator: (value) => value.isEmpty ? '*Required' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                formSpacing,
                _pickedImage == null
                    ? Text(
                        'Add a Tribe photo',
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    : AspectRatio(
                        aspectRatio: 1,
                        child: Image.file(
                          File(_pickedImage.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                FormField(
                    builder: (state) => state.hasError
                        ? Text(
                            state.errorText,
                            style: TextStyle(color: Colors.red[700]),
                          )
                        : const SizedBox(),
                    validator: (value) => _pickedImage == null
                        ? '*You must pick an image'
                        : null),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        var pickedImage =
                            await _picker.getImage(source: ImageSource.gallery);
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        _pickedImage = _pickedImage;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.photo),
                        Text(
                            '${_pickedImage == null ? 'Pick' : 'Change'} Photo')
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async => exitDialog(context),
    );
  }
}
