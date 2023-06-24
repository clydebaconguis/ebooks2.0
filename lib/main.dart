import 'package:ebooks/pages/all_books.dart';
import 'package:ebooks/pages/nav_pdf.dart';
import 'package:ebooks/pdf_view/pdf_view.dart';
import 'package:ebooks/provider/navigation_provider.dart';
import 'package:ebooks/splash_screen.dart';
import 'package:ebooks/welcome/welcome_page.dart';
import 'package:ebooks/widget/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const Welcome());
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
          theme: ThemeData(primarySwatch: Colors.deepOrange),
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
