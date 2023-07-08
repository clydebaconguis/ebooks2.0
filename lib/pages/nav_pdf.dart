import 'package:ebooks/models/pdf_tile.dart';
import 'package:ebooks/pdf_view/pdf_view.dart';
import 'package:ebooks/provider/navigation_provider2.dart';
import 'package:ebooks/widget/navigation_drawer_widget_02.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyNav2 extends StatelessWidget {
  // static const String title = 'Demo';
  final String path;
  final PdfTile books;

  const MyNav2({super.key, required this.path, required this.books});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => NavigationProvider2(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: books.title,
          home: NavPdf(
            path: path,
            books: books,
          ),
        ),
      );
}

class NavPdf extends StatefulWidget {
  final String path;
  final PdfTile books;
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
        drawer: const NavigationDrawerWidget2(),
        appBar: AppBar(
          // leading: IconButton(
          //   padding: EdgeInsets.zero,
          //   constraints: const BoxConstraints(),
          //   icon: const Icon(Icons.arrow_back_ios, color: Color(0xffffffff)),
          //   onPressed: () => Navigator.of(context).pushAndRemoveUntil(
          //       MaterialPageRoute(
          //         builder: (context) => const MyNav(),
          //       ),
          //       (Route<dynamic> route) => false),
          // ),
          backgroundColor: const Color(0xff292735),
          title: Text(widget.books.title),
          centerTitle: true,
        ),
        body: PdfView(path: widget.path, books: widget.books),
      );
}
