import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user/user.dart';
import '../user/user_data.dart';
import '../widget/display_image_widget.dart';
import 'edit_description.dart';
import 'edit_email.dart';
import 'edit_image.dart';
import 'edit_name.dart';
import 'edit_phone.dart';

// This class handles the Page to dispaly the user's info on the "Edit Profile" Screen
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var user = UserData.myUser;
  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final json = preferences.getString('user');

    setState(() {
      user = json == null ? UserData.myUser : User.fromJson(jsonDecode(json));
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = UserData.myUser;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              leading: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xffffffff),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: const Color(0xff292735),
              title: const Text('Profile Page'),
            ),
            SizedBox(height: height * 0.05),
            // const Center(
            //   child: Padding(
            //     padding: EdgeInsets.only(bottom: 20),
            //     child: Text(
            //       'Edit Profile',
            //       style: TextStyle(
            //         fontSize: 30,
            //         fontWeight: FontWeight.w700,
            //         color: Color.fromRGBO(207, 22, 127, 1.0),
            //       ),
            //     ),
            //   ),
            // ),
            InkWell(
                onTap: () {
                  navigateSecondPage(EditImagePage(
                    user: user,
                  ));
                },
                child: user.image.isNotEmpty
                    ? DisplayImage(
                        imagePath: user.image,
                        onPressed: () {},
                      )
                    : Image.asset("img/CK_logo.png")),
            buildUserInfoDisplay(
              user.name,
              'Name',
              EditNameFormPage(user: user),
            ),
            buildUserInfoDisplay(
              user.mobilenum,
              'Phone',
              EditPhoneFormPage(user: user),
            ),
            buildUserInfoDisplay(
              user.email,
              'Email',
              EditEmailFormPage(user: user),
            ),
            // buildAbout(user),
          ],
        ),
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String getValue, String title, Widget editPage) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            Container(
              width: 350,
              height: 40,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              ))),
              child: Row(
                children: [
                  Expanded(
                      child: TextButton(
                          onPressed: () {
                            navigateSecondPage(editPage);
                          },
                          child: Text(
                            getValue,
                            style: const TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                color: Color(0xFFCF167F)),
                          ))),
                  const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                    size: 40.0,
                  )
                ],
              ),
            )
          ],
        ),
      );

  // Widget builds the About Me Section
  Widget buildAbout(User user) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tell Us About Yourself',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 1),
          Container(
              width: 350,
              height: 200,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              ))),
              child: Row(children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      navigateSecondPage(const EditDescriptionFormPage());
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          user.aboutMeDescription,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.4,
                            color: Color(0xFFCF167F),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                  size: 40.0,
                )
              ]))
        ],
      ));

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}
