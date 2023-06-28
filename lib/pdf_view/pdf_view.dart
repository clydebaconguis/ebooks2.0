import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:ebooks/api/my_api.dart';
import 'package:ebooks/models/get_books_info_02.dart';
import 'package:ebooks/models/pdf_tile.dart';
import 'package:ebooks/provider/navigation_provider2.dart';
import 'package:ebooks/widget/navigation_drawer_widget_02.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:path_provider/path_provider.dart';

import '../provider/navigation_provider.dart';
import '../widget/navigation_drawer_widget.dart';

class PdfView extends StatelessWidget {
  final String path;
  final PdfTile books;
  const PdfView({super.key, required this.path, required this.books});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => NavigationProvider2(),
        child: PDFViewPage(
          path: path,
          books: books,
        ),
      );
}

class PDFViewPage extends StatefulWidget {
  final String path;
  final PdfTile books;
  // final Book bookInfo;
  const PDFViewPage({super.key, required this.path, required this.books});

  @override
  State<PDFViewPage> createState() => _PDFViewPage();
}

const snackBar = SnackBar(
  content: Text('Downloading...'),
);
const snackBar2 = SnackBar(
  content: Text('File already exist!'),
);
const snackBar3 = SnackBar(
  content: Text('Already Downloaded!'),
);

class _PDFViewPage extends State<PDFViewPage> {
  bool fileExists = false;
  bool downloaded = false;

  // var url =
  //     'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf';
  late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerStateKey = GlobalKey();

  void showDownloadProgress(received, total) {
    if (total != -1) {
      // print((received / total * 100).toStringAsFixed(0) + '%');
    }
  }

  Future<void> restrictScreenshot() async {
    await FlutterWindowManager.addFlags(
      FlutterWindowManager.FLAG_SECURE,
    );
  }

  @override
  void initState() {
    // scanLocalDir(fileExists, url);
    _pdfViewerController = PdfViewerController();
    restrictScreenshot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        endDrawer: const NavigationDrawerWidget2(),
        body: (widget.path.isNotEmpty)
            ? SfPdfViewer.file(
                File(widget.path),
                controller: _pdfViewerController,
                key: _pdfViewerStateKey,
              )
            : (widget.books.path.isNotEmpty)
                ? Image.file(
                    height: double.infinity,
                    width: double.infinity,
                    File(widget.books.path),
                    fit: BoxFit.fill,
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

  Future<void> scanLocalDir(bool fileExists, url) async {
    var dir = await getApplicationSupportDirectory();
    var last = splitPath(url);
    var path = '${dir.path}/$last';

    fileExists = File(path).existsSync();
    if (fileExists) {
      setState(() {
        fileExists = true;
        downloaded = true;
      });
    } else {
      print('url pdf path NO-EXIST $path');
    }
  }

  viewPDFLocal() {}
  // Future<void> checkpermission(Permission permission, BuildContext context) async {
  //   final status = await permission.request();
  //   if(status==true){
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: content))
  //   }
  // }
}

String splitPath(url) {
  File file = File(url);
  String filename = file.path.split(Platform.pathSeparator).last;
  return filename;
}
