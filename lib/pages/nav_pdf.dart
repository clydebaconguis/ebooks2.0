import 'package:ebooks/pages/all_books.dart';
import 'package:ebooks/pages/nav_main.dart';
import 'package:ebooks/pdf_view/pdf_view.dart';
import 'package:ebooks/provider/navigation_provider.dart';
import 'package:ebooks/provider/navigation_provider2.dart';
import 'package:ebooks/widget/navigation_drawer_widget.dart';
import 'package:ebooks/widget/navigation_drawer_widget_02.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/get_books_info_02.dart';

class MyNav2 extends StatelessWidget {
  static const String title = 'Ebooks Demo';
  final String path;
  final Books2 books;

  const MyNav2({super.key, required this.path, required this.books});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => NavigationProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          home: NavPdf(
            path: path,
            books: books,
          ),
        ),
      );
}

class NavPdf extends StatefulWidget {
  final String path;
  final Books2 books;
  const NavPdf({super.key, required this.path, required this.books});

  @override
  State<NavPdf> createState() => _NavPdfState();
}

class _NavPdfState extends State<NavPdf> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        endDrawer: const NavigationDrawerWidget(),
        appBar: AppBar(
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xffffffff)),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const MyNav(),
                ),
                (Route<dynamic> route) => false),
          ),
          backgroundColor: const Color(0xff292735),
          title: const Text(MyNav2.title),
          centerTitle: true,
        ),
        body: PdfView(path: widget.path, books: widget.books),
      );
}
