import 'package:ebooks/pages/all_books.dart';
import 'package:ebooks/provider/navigation_provider.dart';
import 'package:ebooks/widget/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class MyNav extends StatelessWidget {
  static const String title = 'Demo';

  const MyNav({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => NavigationProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          home: const NavMain(),
          builder: EasyLoading.init(),
        ),
      );
}

class NavMain extends StatefulWidget {
  const NavMain({super.key});

  @override
  State<NavMain> createState() => _NavMainState();
}

class _NavMainState extends State<NavMain> {
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const NavigationDrawerWidget(),
        appBar: AppBar(
          titleSpacing: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff500a34), Color(0xffcf167f)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // backgroundColor: const Color(0xff500a34),
          title: Image.asset(
            "img/liceo-logo.png",
            height: 48,
            width: 48,
          ),
        ),
        body: const AllBooks(),
      );
}
