import 'dart:io';

import 'package:ebooks/app_util.dart';
import 'package:ebooks/pages/all_books.dart';
import 'package:ebooks/provider/navigation_provider.dart';
import 'package:ebooks/splash_screen.dart';
import 'package:ebooks/widget/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  deleteExpiredBooks();

  runApp(const Splash());
}

deleteExpiredBooks() async {
  var result = await AppUtil().readBooks();
  result.forEach((item) {
    final directory = Directory(item.path);
    final now = DateTime.now();
    final lastModified = File(directory.path).statSync().modified;
    final difference = now.difference(lastModified);
    if (difference.inDays >= 365) {
      directory.deleteSync(recursive: true);
    }
  });
}

String splitPath(url) {
  File file = File(url);
  String filename = file.path.split(Platform.pathSeparator).last;
  return filename;
}

class MyApp extends StatelessWidget {
  static const String title = 'EBooks Demo';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => NavigationProvider(),
        child: const MaterialApp(
          color: Colors.black12,
          debugShowCheckedModeBanner: false,
          title: title,
          // theme: ThemeData(
          //   textTheme: GoogleFonts.promp(
          //     Theme.of(context).textTheme,
          //   ),
          // ),
          home: AllBooks(),
        ),
      );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    changeStatusBarColor();
    super.initState();
  }

  changeStatusBarColor() async {
    await FlutterStatusbarcolor.setStatusBarColor(const Color(0xff500a34));
    if (useWhiteForeground(const Color(0xff500a34))) {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    }
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(statusBarColor: Color(0xff500a34)),
        child: Scaffold(
          drawer: const NavigationDrawerWidget(),
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              MyApp.title,
            ),
          ),
        ),
      );
}
