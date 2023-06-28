// import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:ebooks/app_util.dart';
import 'package:ebooks/models/get_books_info.dart';
import 'package:ebooks/models/get_lessons.dart';
import 'package:ebooks/models/pdf_tile.dart';
import 'package:ebooks/pages/nav_pdf.dart';
import 'package:ebooks/pdf_view/pdf_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_app_backend/components/text_widget.dart';
// import 'package:flutter_app_backend/models/get_article_info.dart';

import '../api/my_api.dart';
import '../components/text_widget.dart';
import '../models/get_books_info_02.dart';
import 'all_books.dart';

class DetailBookPage extends StatefulWidget {
  final Books2 bookInfo;
  final int index;
  const DetailBookPage({Key? key, required this.bookInfo, required this.index})
      : super(key: key);

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  final String mainHost = CallApi().getHost();
  List<Lessons> lessons = [];
  bool _isLoading = false;

  @override
  void initState() {
    // _storeBookId();
    _fetchParts();
    // readSpecificBook();
    super.initState();
  }

  // readSpecificBook() async {
  //   var dir = await getApplicationSupportDirectory();
  //   final pathFile = Directory(dir.path);
  //   final List<FileSystemEntity> entities = await pathFile.list().toList();
  //   final Iterable<Directory> files = entities.whereType<Directory>();
  //   files.forEach((element) {
  //     print(element.absolute);
  //   });
  //   // // return files;
  //   // entities.forEach((element) {
  //   //   print(element.path);
  //   // });
  //   // print(entities);
  //   // pathFile.deleteSync(recursive: true);
  //   // entities.forEach((element) {
  //   //   print(element.path);
  //   // });
  //   // print(entities);
  // }

  _fetchParts() async {
    CallApi().getPublicData('bookchapter/${widget.bookInfo.bookid}').then(
      (response) {
        setState(
          () {
            Iterable list = json.decode(response.body);
            lessons = list.map((e) => Lessons.fromJson(e)).toList();
            if (kDebugMode) {
              print("size : ${lessons.length}");
            }
          },
        );
      },
    );
  }
  //   throw Exception('Failed to load post');

  // imageExist(String folderName) async {
  //   final Directory appDir = await getApplicationSupportDirectory();
  //   // const folderName = 'SampleBook';
  //   final Directory appDirFolder =
  //       Directory("${appDir.path}/$folderName/cover_image");
  //   if (await appDirFolder.exists()) {
  //     //if folder already exists return path
  //     print(appDirFolder.path);
  //     return appDirFolder.path;
  //   } else {
  //     //if folder not exists create folder and then return its path
  //     return '';
  //   }
  // }

  Future<bool> fileExist(String folderName) async {
    final Directory appDir = await getApplicationSupportDirectory();
    // const folderName = 'SampleBook';
    final Directory appDirFolder = Directory("${appDir.path}/$folderName/");
    if (await appDirFolder.exists()) {
      // File imageFile = File("$appDir/${widget.bookInfo.title}/cover_image");
      // if (await imageFile.exists()) {
      //   setState(() {
      //     imgPathLocal = imageFile.path;
      //   });
      // }
      //if folder already exists return path
      return true;
    } else {
      //if folder not exists create folder and then return its path
      return false;
    }
  }

  downloadImage(String foldr, String filename, String imgUrl) async {
    String host = "$mainHost$imgUrl";
    var savePath = '$foldr$filename';
    // print(savePath);
    var dio = Dio();
    dio.interceptors.add(LogInterceptor());
    try {
      var response = await dio.get(
        host,
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
      print("image dowloaded successfully");
    } catch (e) {
      debugPrint(e.toString());
      print("image failed to download");
    }
  }

  // checkImageExist() async {
  //   imgPathLocal = await imageExist(widget.bookInfo.title);
  // }

  _downloadPdf() async {
    final Directory appDir = await getApplicationSupportDirectory();
    var imgPathLocal = "${appDir.path}/${widget.bookInfo.title}/cover_image";
    setState(() {
      _isLoading = true;
    });
    _isLoading = true;
    var exist = await fileExist(widget.bookInfo.title);
    if (exist) {
      print("file already exist!");
      Timer(const Duration(seconds: 2), () {
        // <-- Delay here
        setState(() {
          _isLoading = false;
          // final Directory imgPath =
          //     Directory("${appDir.path}/${widget.bookInfo.title}/cover_image");
          // var imgUrl = "${appDir.path}/${widget.bookInfo.title}/cover_image";
          saveCurrentBook(widget.bookInfo.title);
          navigateToMainNav(imgPathLocal); // <-- Code run after delay
        });
      });
    } else {
      final Directory appDirFolder =
          Directory("${appDir.path}/${widget.bookInfo.title}/");
      print(appDirFolder.path);
      //if folder not exists create folder and then return its path
      final Directory bookNewFolder =
          await appDirFolder.create(recursive: true);
      print(bookNewFolder.path);
      downloadImage(bookNewFolder.path, "cover_image", widget.bookInfo.picurl);
      lessons.forEach((element) async {
        if (element.path.isNotEmpty) {
          String filename = AppUtil().splitPath(element.path);
          downloadPdFiles(element.path, filename, bookNewFolder.path);
          // readSpecificBook();

          // if (kDebugMode) {
          //   print('${element.chaptertitle} - ${element.path}');
          // }
        }
      });
      Timer(const Duration(seconds: 3), () {
        // <-- Delay here
        setState(() {
          _isLoading = false;
          saveCurrentBook(widget.bookInfo.title);
          navigateToMainNav(
              "${bookNewFolder.path}cover_image"); // <-- Code run after delay
        });
      });
      checkLoading();
    }
  }

  checkLoading() {
    if (_isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preparing..."),
        backgroundColor: Colors.pink,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Redirecting..."),
        backgroundColor: Colors.pink,
      ));
    }
  }

  navigateToMainNav(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyNav2(
          books: PdfTile(title: widget.bookInfo.title, path: path),
          path: '',
        ),
      ),
    );
  }

  Future<void> saveCurrentBook(bookName) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('currentBook', bookName);
  }

  downloadPdFiles(
    String url,
    String filename,
    String bookFolderDir,
  ) async {
    String host = "$mainHost/$url";
    var savePath = '$bookFolderDir$filename';
    // print(savePath);
    var dio = Dio();
    dio.interceptors.add(LogInterceptor());
    try {
      print("Downloading...");

      var response = await dio.get(
        host,
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
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 30,
            backgroundColor: const Color(0xFFffffff),
            elevation: 0.0,
          ),
          body: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 0, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Color(0xff232324)),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Material(
                        elevation: 0.0,
                        child: widget.bookInfo.picurl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: '$mainHost${widget.bookInfo.picurl}',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 200,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3))
                                    ],
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : Container(
                                height: 200,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: const DecorationImage(
                                    image: AssetImage("img/CK_logo.png"),
                                  ),
                                ),
                              ),
                      ),
                      Container(
                        width: screenWidth - 30 - 180 - 20,
                        margin: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            TextWidget(
                              color: const Color(0xf21ca2c4),
                              text: widget.bookInfo.title,
                              fontSize: 30,
                            ),
                            TextWidget(
                                text:
                                    "Publish: ${widget.bookInfo.createddatetime}",
                                fontSize: 20,
                                color: const Color(0xFF7b8ea3)),
                            const Divider(color: Colors.grey),
                            // TextWidget(
                            //     text: widget.bookInfo.description,
                            //     fontSize: 16,
                            //     color: const Color(0xFF7b8ea3)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Divider(color: Color(0xFF7b8ea3)),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.favorite,
                              color: Color(0xFF7b8ea3),
                              size: 40,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            TextWidget(text: "Like", fontSize: 20),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.share,
                              color: Color(0xFF7b8ea3),
                              size: 40,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            TextWidget(text: "Share", fontSize: 20),
                          ],
                        ),
                        // Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: <Widget>[
                        //     Icon(
                        //       Icons.download_for_offline,
                        //       color: Color(0xFF7b8ea3),
                        //       size: 40,
                        //     ),
                        //     SizedBox(
                        //       width: 10,
                        //     ),
                        //     TextWidget(text: "Download", fontSize: 20),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Row(
                    children: [
                      TextWidget(
                        text: "Details",
                        fontSize: 30,
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: TextWidget(
                      color: Colors.grey,
                      text:
                          'This book was brought to you by CK Children\'s Publishing Company.',
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // SizedBox(
                  //   height: 200,
                  // child: TextWidget(
                  //     // text: widget.bookInfo.article_content,
                  //     text: widget.bookInfo.content,
                  //     fontSize: 16,
                  //     color: Colors.grey),
                  // ),
                  const Divider(color: Color(0xFF7b8ea3)),
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _downloadPdf();
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.pink,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: 10.0,
                                bottom: 10.0,
                              ),
                              alignment: Alignment.center),
                          child: const Text(
                            "View Book",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        // Expanded(child: Container()),
                        // const IconButton(
                        //     icon: Icon(Icons.arrow_forward_ios),
                        //     onPressed: null)
                      ],
                    ),
                  ),
                  // const Divider(color: Color(0xFF7b8ea3)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
