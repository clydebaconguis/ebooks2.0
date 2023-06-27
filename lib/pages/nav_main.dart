import 'package:ebooks/models/pdf_tile.dart';
import 'package:ebooks/pages/all_books.dart';
import 'package:ebooks/provider/navigation_provider.dart';
import 'package:ebooks/widget/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyNav extends StatelessWidget {
  static const String title = 'Demo';

  const MyNav({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => NavigationProvider(),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          home: NavMain(),
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
          backgroundColor: const Color(0xff292735),
          title: const Text(MyNav.title),
          centerTitle: true,
        ),
        body: const AllBooks(),
      );
}
