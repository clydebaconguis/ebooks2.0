import 'package:dots_indicator/dots_indicator.dart';
import 'package:ebooks/auth/auth_page.dart';
import 'package:ebooks/pages/nav_main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // theme: ThemeData(
      //   textTheme: GoogleFonts.poppinsTextTheme(
      //     Theme.of(context).textTheme,
      //   ),
      // ),
      home: WelcomePage(),
      debugShowCheckedModeBanner: false,
      title: 'Ebook',
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  var articles = <String>[
    "Welcome to ICT-eBook. We’re excited to have you on board.",
    "Powered by CK Your Access to Visual Learning and Integration",
    "Access Books Anytime, Anywhere.",
  ];
  final _totalDots = 3;
  double _currentPosition = 0.0;
  bool isLoggedIn = false;

  @override
  void initState() {
    // _initData();
    _checkLoginStatus();
    super.initState();
  }

  _checkLoginStatus() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token')!;
    if (token.isNotEmpty) {
      setState(() {
        isLoggedIn = true;
      });
    }
    isLoggedIn ? navigateToMainNav() : {};
  }

  navigateToMainNav() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MyNav(),
        ),
        (Route<dynamic> route) => false);
  }

  double _validPosition(double position) {
    if (position >= _totalDots) return 0;
    if (position < 0) return _totalDots - 1.0;
    return position;
  }

  void _updatePosition(double position) {
    setState(() => _currentPosition = _validPosition(position));
  }

  Widget _buildRow(List<Widget> widgets) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widgets,
      ),
    );
  }

  String getCurrentPositionPretty() {
    return (_currentPosition + 1.0).toStringAsPrecision(2);
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPosition = _currentPosition.ceilToDouble();
      // _updatePosition(max(--_currentPosition, 0));
      _updatePosition(index.toDouble());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff292735),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("img/background-welcome.png"),
                    fit: BoxFit.fill)),
          ),
          _buildRow(
            [
              DotsIndicator(
                dotsCount: _totalDots,
                position: _currentPosition.toInt(),
                axis: Axis.horizontal,
                decorator: DotsDecorator(
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeColor: const Color(0xffcf167f),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onTap: (pos) {
                  setState(() => _currentPosition = pos.ceilToDouble());
                },
              )
            ],
          ),
          Container(
            height: 180,
            color: const Color(0xff292735),
            child: PageView.builder(
              onPageChanged: _onPageChanged,
              controller: PageController(viewportFraction: 1.0),
              itemCount: articles.isNotEmpty ? articles.length : 0,
              itemBuilder: (_, i) {
                return Container(
                  height: 180,
                  padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(right: 10),
                  child: Text(
                    articles[i].isEmpty ? "Nothing " : articles[i],
                    style: GoogleFonts.prompt(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 22),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  height: 80,
                  bottom: 80,
                  left: (MediaQuery.of(context).size.width - 200) / 2,
                  right: (MediaQuery.of(context).size.width - 200) / 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const AuthPage(),
                          ),
                          (Route<dynamic> route) => false);
                    },
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(0xffcf167f),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Get Started',
                            style: GoogleFonts.prompt(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
