import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:path_provider/path_provider.dart';

// void main() => runApp(const PdfView());

class PdfView extends StatelessWidget {
  const PdfView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Syncfusion Flutter PDF Viewer',
      home: PDFViewPage(),
    );
  }
}

class PDFViewPage extends StatefulWidget {
  const PDFViewPage({super.key});

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
  // var url = 'https://www.africau.edu/images/default/sample.pdf';
  var url =
      'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf';
  late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerStateKey = GlobalKey();

  void showDownloadProgress(received, total) {
    if (total != -1) {
      // print((received / total * 100).toStringAsFixed(0) + '%');
    }
  }

  Future download(String url, String filename) async {
    if (!fileExists) {
      var dir = await getApplicationSupportDirectory();
      var savePath = '${dir.path}/$filename';
      // print(savePath);
      var dio = Dio();
      dio.interceptors.add(LogInterceptor());
      try {
        var response = await dio.get(
          url,
          onReceiveProgress: showDownloadProgress,
          //Received data with List<int>
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: const Duration(seconds: 60),
          ),
        );
        var file = File(savePath);
        var raf = file.openSync(mode: FileMode.write);
        // response.data is List<int> type
        raf.writeFromSync(response.data);
        await raf.close();
        setState(() {
          fileExists = true;
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar3);
    }
  }

  Future<void> restrictScreenshot() async {
    await FlutterWindowManager.addFlags(
      FlutterWindowManager.FLAG_SECURE,
    );
  }

  @override
  void initState() {
    scanLocalDir(fileExists, url);
    _pdfViewerController = PdfViewerController();
    restrictScreenshot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        title: const Text('Flutter PDF Viewer'),
        actions: [
          downloaded
              ? IconButton(
                  onPressed: () =>
                      {ScaffoldMessenger.of(context).showSnackBar(snackBar2)},
                  icon: const Icon(Icons.download_done),
                )
              : IconButton(
                  onPressed: () => setState(() {
                    downloaded = true;
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    download(url, splitPath(url));
                  }),
                  icon: const Icon(Icons.download),
                ),
          IconButton(
            onPressed: () =>
                _pdfViewerStateKey.currentState!.openBookmarkView(),
            icon: const Icon(Icons.bookmark),
          ),
          IconButton(
            onPressed: () => _pdfViewerController.zoomLevel = 1.25,
            icon: const Icon(Icons.zoom_in),
          ),
        ],
      ),
      body: SfPdfViewer.network(
        url,
        controller: _pdfViewerController,
        key: _pdfViewerStateKey,
      ),
    );
  }

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
