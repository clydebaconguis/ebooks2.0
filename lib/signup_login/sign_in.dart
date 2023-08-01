import 'dart:async';
import 'dart:convert';
import 'package:ebooks/api/my_api.dart';
import 'package:ebooks/components/text_widget.dart';
import 'package:ebooks/pages/nav_main.dart';
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
  bool isButtonEnabled = true;
  // late bool _isLoading = false;
  TextEditingController textController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
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
        // print(body);
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
      // print('Error during login: $e');
      EasyLoading.showError('An error occurred during login');
    } finally {
      EasyLoading.dismiss();
    }
    setState(() {
      isButtonEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          // Prevent navigating back by returning false
          return false;
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: height * 0.1),
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.transparent,
                      child: Image.asset("img/liceo-logo.png"),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextInput(
                        textString: "Email",
                        textController: emailController,
                        hint: "Email"),
                    const SizedBox(
                      height: 30,
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
                          style: GoogleFonts.prompt(
                            textStyle: const TextStyle(
                                color: Color.fromARGB(
                                  255,
                                  209,
                                  22,
                                  128,
                                ),
                                fontWeight: FontWeight.w900,
                                fontSize: 26),
                          ),
                        ),
                        GestureDetector(
                          onTap: isButtonEnabled
                              ? () {
                                  if (textController.text.isEmpty ||
                                      emailController.text.isEmpty) {
                                    EasyLoading.showToast(
                                      'Fill all fields!',
                                      toastPosition:
                                          EasyLoadingToastPosition.bottom,
                                    );
                                  } else {
                                    setState(() {
                                      isButtonEnabled = false;
                                    });
                                    _login();
                                  }
                                }
                              : null,
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isButtonEnabled
                                  ? const Color(0xFF99135F)
                                  : Colors.grey,
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
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Color(0xFF000000)),
      cursorColor: const Color(0xFF9b9b9b),
      controller: widget.textController,
      keyboardType: TextInputType.text,
      obscureText: widget.textString == "Password" ? _obscureText : false,
      focusNode: _focusNode,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: _isFocused ? Colors.blue : Colors.grey,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 15, horizontal: 16), // Adjust the vertical padding here
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
