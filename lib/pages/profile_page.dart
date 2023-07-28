import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user/user.dart';
import '../user/user_data.dart';
// import '../widget/display_image_widget.dart';
import 'edit_description.dart';
// import 'edit_email.dart';
// import 'edit_name.dart';
// import 'edit_phone.dart';

// This class handles the Page to dispaly the user's info on the "Edit Profile" Screen
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var user = UserData.myUser;
  String grade = '';
  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final json = preferences.getString('user');
    grade = preferences.getString('grade')!;
    setState(() {
      user = json == null ? UserData.myUser : User.fromJson(jsonDecode(json));
    });
  }

  @override
  Widget build(BuildContext context) {
    // final double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  "Profile",
                  style: GoogleFonts.prompt(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                ),
              ),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff500a34), Color(0xffcf167f)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 140, 228, 243),
                              radius: 60.0,
                              backgroundImage: AssetImage(
                                'img/anonymous.jpg', // Replace with the actual profile picture URL
                              ),
                            ),
                            const SizedBox(height: 22),
                            Text(
                              user.name,
                              style: GoogleFonts.prompt(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff500a34),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 25.0),
                            buildProfileItem(
                                Icons.phone,
                                'Phone',
                                user.mobilenum.isNotEmpty
                                    ? user.mobilenum
                                    : 'Not Specified'),
                            const Divider(),
                            buildProfileItem(Icons.school, 'Grade Level',
                                grade.isNotEmpty ? grade : 'Not Specified'),
                            const Divider(),
                            buildProfileItem(
                                Icons.email,
                                'Email',
                                user.email.isNotEmpty
                                    ? user.email
                                    : 'Not Specified'),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )

              // SizedBox(height: height * 0.05),
              // InkWell(
              //   onTap: () {
              //     // navigateSecondPage(EditImagePage(
              //     //   user: user,
              //     // ));
              //   },
              //   child: DisplayImage(
              //     imagePath: 'img/anonymous.jpg',
              //     onPressed: () {},
              //   ),
              // ),
              // buildUserInfoDisplay(
              //   user.name,
              //   'Name',
              //   EditNameFormPage(user: user),
              // ),
              // buildUserInfoDisplay(
              //   user.mobilenum,
              //   'Phone',
              //   EditPhoneFormPage(user: user),
              // ),
              // buildUserInfoDisplay(
              //   grade,
              //   'Grade Level',
              //   EditPhoneFormPage(user: user),
              // ),
              // buildUserInfoDisplay(
              //   user.email,
              //   'Email',
              //   EditEmailFormPage(user: user),
              // ),
              // buildAbout(user),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54),
        const SizedBox(width: 8.0),
        Text(
          '$label:',
          style: GoogleFonts.prompt(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.prompt(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: true,
          ),
        ),
      ],
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
                            // navigateSecondPage(editPage);
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
