import 'dart:convert';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:ebooks/api/my_api.dart';
import 'package:ebooks/auth/auth_page.dart';
import 'package:ebooks/models/get_articles_info.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
  var articles = <ArticleInfo>[];
  final _totalDots = 3;
  double _currentPosition = 0.0;

  @override
  void initState() {
    _initData();
    super.initState();
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

  _initData() async {
    CallApi().getPublicData('welcome').then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print(list);
        articles = list.map((model) => ArticleInfo.fromJson(model)).toList();
      });
    });
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
                    articles[i].articleContent.isEmpty
                        ? "Nothing "
                        : articles[i].articleContent,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "Avenir",
                        fontWeight: FontWeight.bold),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AuthPage()));
                    },
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(0xff17bbab),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Get Started',
                            style: TextStyle(color: Colors.white, fontSize: 26),
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
