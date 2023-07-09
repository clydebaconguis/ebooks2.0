import 'dart:io';

import 'package:ebooks/models/pdf_tile.dart';
import 'package:ebooks/pdf_view/pdf_view.dart';
import 'package:ebooks/provider/navigation_provider2.dart';
import 'package:ebooks/widget/navigation_drawer_widget_02.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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

class _NavPdfState extends State<NavPdf>
    with AutomaticKeepAliveClientMixin<NavPdf> {
  @override
  bool get wantKeepAlive => true;
  String title = '';
  String pdfPath = '';

  void updateData(String path, String barTitle) {
    setState(() {
      pdfPath = path;
      title = barTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      drawer: NavigationDrawerWidget2(updateData: updateData),
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
        title: Text(title),
        centerTitle: true,
      ),
      body: pdfPath.isNotEmpty
          ? SfPdfViewer.file(
              File(pdfPath),
              canShowPaginationDialog: false,
              // controller: _pdfViewerController,
              // key: _pdfViewerStateKey,
            )
          : (widget.books.path.isNotEmpty)
              ? Image.file(
                  height: double.infinity,
                  width: double.infinity,
                  File(widget.books.path),
                  fit: BoxFit.contain,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    // Return a fallback image or widget when an error occurs
                    return Image.asset('img/CK_logo.png');
                  },
                )
              : Center(
                  child: Image.asset(
                    "img/CK_logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
    );
  }
}
