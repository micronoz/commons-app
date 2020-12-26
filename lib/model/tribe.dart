class Tribe {
  String name;
  String id;
  List<String> admins;
  List<String> members;
  List<String> posts;
  List<String> photos;
  String mainPhoto;
  String description;

  Tribe() {
    name = 'Nabizers';
    id = '1';
    admins = ['1'];
    members = ['1'];
    posts = ['23', '12', '2'];
    photos = [
      'https://picsum.photos/250?image=12',
      'https://picsum.photos/250?image=13'
    ];
    description = 'Welcome to the family...';
    mainPhoto = 'https://picsum.photos/250?image=14';
  }
}
