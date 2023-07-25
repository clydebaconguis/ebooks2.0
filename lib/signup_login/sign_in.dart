import 'dart:async';
import 'dart:convert';
import 'package:ebooks/api/my_api.dart';
import 'package:ebooks/components/text_widget.dart';
import 'package:ebooks/pages/nav_main.dart';
import 'package:ebooks/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

const snackBar2 = SnackBar(
  content: Text('Fill all fields!'),
);

class _SignInState extends State<SignIn> {
  var loggedIn = false;
  var domain = '';
  // late bool _isLoading = false;
  TextEditingController textController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    _loadSavedDomainName();
    super.initState();
  }

  _navigateToBooks() {
    EasyLoading.showSuccess('Great Success!');
    Timer(const Duration(milliseconds: 200), () {
      // <-- Delay here
      EasyLoading.dismiss();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MyNav(),
          ),
          (Route<dynamic> route) => false);
    });
  }

  _loadSavedDomainName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var savedDomainName = prefs.getString('domainname') ?? '';
    setState(() {
      domain = savedDomainName;
    });
    if (domain.isNotEmpty) {
      if (textController.text.isNotEmpty || emailController.text.isNotEmpty) {
        _login();
      }
    } else {
      EasyLoading.showInfo("Domain Not Configured");
    }
  }

  _login() async {
    EasyLoading.show(status: 'loading...');
    var data = {
      'email': emailController.text,
      'password': textController.text,
    };

    try {
      var res = await CallApi().login(data, 'studentlogin');
      var body = {};
      if (res != null) {
        body = json.decode(res.body);
        print(body);
      }

      if (body['success']) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', body['user']['name']);
        localStorage.setString('grade', body['grade']);
        localStorage.setString('user', json.encode(body['user']));
        _navigateToBooks();
      } else {
        EasyLoading.showError('Failed to Login');
      }
    } catch (e) {
      print('Error during login: $e');
      EasyLoading.showError('An error occurred during login');
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: const EdgeInsets.only(left: 30, right: 40),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    horizontalTitleGap: 0,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Setting(),
                      ),
                    ),
                    leading: const Icon(
                      Icons.settings_suggest_rounded,
                      color: Colors.black,
                      size: 35,
                    ),
                    title: const Text(
                      "Configure Domain",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  SizedBox(height: height * 0.1),
                  Text(
                    'You’re One Step Away From Greatness',
                    style: GoogleFonts.permanentMarker(
                      textStyle: const TextStyle(
                          fontSize: 30,
                          color: Color.fromARGB(255, 209, 22,
                              128) // Adjust the font size as needed.
                          // You can add other text styles such as color, fontWeight, etc. here.
                          ),
                    ),
                  ),
                  SizedBox(height: height * 0.1),
                  TextInput(
                      textString: "Email",
                      textController: emailController,
                      hint: "Email"),
                  SizedBox(
                    height: height * .05,
                  ),
                  TextInput(
                    textString: "Password",
                    textController: textController,
                    hint: "Password",
                    obscureText: true,
                  ),
                  SizedBox(
                    height: height * .05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sign in',
                        style: GoogleFonts.permanentMarker(
                          textStyle: const TextStyle(
                              fontSize: 22,
                              color: Color.fromARGB(255, 209, 22,
                                  128) // Adjust the font size as needed.
                              // You can add other text styles such as color, fontWeight, etc. here.
                              ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (textController.text.isEmpty ||
                              emailController.text.isEmpty) {
                            EasyLoading.showToast(
                              'Fill all fields!',
                              toastPosition: EasyLoadingToastPosition.bottom,
                            );
                          } else {
                            _loadSavedDomainName();
                          }
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 209, 22, 128),
                          ),
                          child: const Icon(Icons.arrow_forward,
                              color: Colors.white, size: 30),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * .1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const SignUp(),
                          //   ),
                          // );
                          EasyLoading.showInfo(
                              'Sign up is temporarily unavailable!');
                        },
                        child: const TextWidget(
                          color: Color(0xffcf167f),
                          text: "Sign up",
                          fontSize: 16,
                          isUnderLine: true,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          EasyLoading.showInfo(
                              'Pls inform the authority or your teacher if you forgot your credentials!');
                        },
                        child: const TextWidget(
                          color: Color(0xffcf167f),
                          text: "Forgot Password",
                          fontSize: 16,
                          isUnderLine: true,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      builder: EasyLoading.init(),
    );
  }
}

class TextInput extends StatefulWidget {
  final String textString;
  final TextEditingController textController;
  final String hint;
  final bool obscureText;
  const TextInput({
    Key? key,
    required this.textString,
    required this.textController,
    required this.hint,
    this.obscureText = false,
  }) : super(key: key);

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Color(0xFF000000)),
      cursorColor: const Color(0xFF9b9b9b),
      controller: widget.textController,
      keyboardType: TextInputType.text,
      obscureText: widget.textString == "Password" ? _obscureText : false,
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffcf167f),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffcf167f),
          ),
        ),
        hintText: widget.textString,
        hintStyle: const TextStyle(
          color: Color(0xFF9b9b9b),
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
        suffixIcon: widget.textString == "Password"
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
