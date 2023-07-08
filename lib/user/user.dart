class User {
  int id;
  String image;
  String name;
  String email;
  String mobilenum;
  String aboutMeDescription;

  // Constructor
  User({
    required this.id,
    required this.image,
    required this.name,
    required this.email,
    required this.mobilenum,
    required this.aboutMeDescription,
  });

  User copy({
    int? id,
    String? image,
    String? name,
    String? mobilenum,
    String? email,
    String? about,
  }) =>
      User(
        id: id ?? this.id,
        image: image ?? this.image,
        name: name ?? this.name,
        email: email ?? this.email,
        mobilenum: mobilenum ?? this.mobilenum,
        aboutMeDescription: about ?? aboutMeDescription,
      );

  // static User fromJson(Map<String, dynamic> json) => User(
  //       image: json['imagePath'],
  //       name: json['name'],
  //       email: json['email'],
  //       aboutMeDescription: json['about'],
  //       phone: json['phone'],
  //     );

  factory User.fromJson(Map json) {
    var id = json['id'] ?? 0;
    var name = json['name'] ?? '';
    var email = json['email'] ?? '';
    var mobilenum = json['mobilenum'] ?? '';
    var about =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat...';
    var image =
        "https://th.bing.com/th/id/OIP.5i32quyHJYp94d_natkAAwHaHa?w=188&h=187&c=7&r=0&o=5&dpr=1.5&pid=1.7";

    return User(
        image: image,
        name: name,
        email: email,
        mobilenum: mobilenum,
        aboutMeDescription: about,
        id: id);
  }

  Map<String, dynamic> toJson() => {
        'image': image,
        'name': name,
        'email': email,
        'about': aboutMeDescription,
        'mobilenum': mobilenum,
      };
}
