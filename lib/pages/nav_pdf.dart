import 'dart:io';

import 'package:ebooks/models/pdf_tile.dart';
import 'package:ebooks/provider/navigation_provider2.dart';
import 'package:ebooks/widget/navigation_drawer_widget_02.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:video_player/video_player.dart';

class MyNav2 extends StatelessWidget {
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
    restrictScreenshot();
    super.initState();
  }

  Future<void> restrictScreenshot() async {
    await FlutterWindowManager.addFlags(
      FlutterWindowManager.FLAG_SECURE,
    );
  }

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
    return SafeArea(
      child: Scaffold(
        drawer: NavigationDrawerWidget2(updateData: updateData),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff500a34), Color(0xffcf167f)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: title.isEmpty ? Text(widget.books.title) : Text(title),
          centerTitle: true,
        ),
        body: (pdfPath.isNotEmpty)
            ? SfPdfViewer.file(
                File(pdfPath),
                canShowPaginationDialog: false,
                canShowScrollHead: false,
              )
            : Image.file(
                File(widget.books.path ?? ''),
              ),
      ),
    );
  }
}
