import 'dart:convert';

// import 'package:flutter/cupertino.dart';
import 'package:ebooks/api/my_api.dart';
import 'package:ebooks/components/text_widget.dart';
import 'package:ebooks/pages/all_books.dart';
import 'package:ebooks/signup_login/sign_up.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_app_backend/api/my_api.dart';
// import 'package:flutter_app_backend/components/text_widget.dart';
// import 'package:flutter_app_backend/pages/article_page.dart';
// import 'package:flutter_app_backend/signup_login/sing_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var loggedIn = false;
  TextEditingController textController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  _showMsg(msg) {
    //
    final snackBar = SnackBar(
      backgroundColor: const Color(0xFF363f93),
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _navigateToBooks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AllBooks(),
      ),
    );
  }

  _login() async {
    var data = {
      'email': emailController.text,
      'password': textController.text,
    };
    print(emailController.text);
    print(textController.text);

    var res = await CallApi().login(data, 'login');
    var body = json.decode(res.body);
    print(body);

    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));
      _navigateToBooks();
    } else {
      _showMsg(body['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.only(left: 30, right: 40),
        child: SafeArea(
          child: ListView(
            children: [
              SizedBox(height: height * 0.1),
              Container(
                padding: const EdgeInsets.only(left: 0, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Color(0xFF363f93)),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true)
                              .pop(context),
                    )
                  ],
                ),
              ),
              SizedBox(height: height * 0.1),
              const TextWidget(
                  text: "You’re One Step Away",
                  fontSize: 26,
                  isUnderLine: false),
              const TextWidget(
                  text: "From Greatness", fontSize: 26, isUnderLine: false),
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
                  const TextWidget(
                      text: "Sign in", fontSize: 22, isUnderLine: false),
                  GestureDetector(
                    onTap: () {
                      _login();
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF363f93),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUp(),
                        ),
                      );
                    },
                    child: const TextWidget(
                        text: "Sign up", fontSize: 16, isUnderLine: true),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const TextWidget(
                        text: "Forgot Password",
                        fontSize: 16,
                        isUnderLine: true),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextInput extends StatelessWidget {
  final String textString;
  final TextEditingController textController;
  final String hint;
  final bool obscureText;
  const TextInput(
      {Key? key,
      required this.textString,
      required this.textController,
      required this.hint,
      this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Color(0xFF000000)),
      cursorColor: const Color(0xFF9b9b9b),
      controller: textController,
      keyboardType: TextInputType.text,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: textString,
        hintStyle: const TextStyle(
            color: Color(0xFF9b9b9b),
            fontSize: 15,
            fontWeight: FontWeight.normal),
      ),
    );
  }
}
