import 'dart:convert';

import 'user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static late SharedPreferences _preferences;
  static const _keyUser = 'user';

  static User myUser = User(
    id: 0,
    image:
        "https://th.bing.com/th/id/OIP.5i32quyHJYp94d_natkAAwHaHa?w=188&h=187&c=7&r=0&o=5&dpr=1.5&pid=1.7",
    name: 'Test Test',
    email: 'test.test@gmail.com',
    mobilenum: '(208) 206-5039',
    aboutMeDescription:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat...',
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(User user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser, json);
  }

  static Future<User> getUser() async {
    _preferences = await SharedPreferences.getInstance();
    final json = _preferences.getString(_keyUser);

    return json == null ? myUser : User.fromJson(jsonDecode(json));
  }
}
