import 'package:flutter/material.dart';

class UserProfile {
  String id;
  String name;
  String identifier;
  ImageProvider photo;
  String description;

  UserProfile(
      this.id, this.name, this.identifier, String photoUrl, this.description) {
    photo = NetworkImage(
      photoUrl,
    );
  }

  UserProfile.mock() : id = '1' {
    name = 'Nabi';
    identifier = 'nozberkman';
    description =
        'Hello my name is Nabi. I\'m from Cyprus and this is the new app I created for bringing people together.';
    photo = NetworkImage('https://picsum.photos/250?image=11');
  }

  @override
  bool operator ==(Object other) {
    if (other is UserProfile) {
      return (id == other.id);
    } else {
      return false;
    }
  }
}
