import 'dart:io';

import 'package:ebooks/app_util.dart';
import 'package:ebooks/pages/all_books.dart';
import 'package:ebooks/provider/navigation_provider.dart';
import 'package:ebooks/splash_screen.dart';
import 'package:ebooks/widget/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

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
        child: MaterialApp(
          color: Colors.black12,
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          home: const AllBooks(),
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
  Widget build(BuildContext context) => Scaffold(
        drawer: const NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            MyApp.title,
          ),
        ),
      );
}
