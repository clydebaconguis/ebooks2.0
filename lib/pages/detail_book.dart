import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:ebooks/models/pdf_tile.dart';
import 'package:ebooks/pages/nav_pdf.dart';
import 'package:ebooks/signup_login/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/my_api.dart';
import '../models/get_books_info_02.dart';
import 'package:disk_space_plus/disk_space_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailBookPage extends StatefulWidget {
  final Books2 bookInfo;
  final int index;
  const DetailBookPage({Key? key, required this.bookInfo, required this.index})
      : super(key: key);

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  String mainHost = CallApi().getHost();
  // List<Lessons> lessons = [];
  bool _isLoading = false;
  double _diskSpace = 0;
  bool lowStorage = false;
  var parts = [];
  var chapters = [];
  var lessons = [];
  var bookCoverUrl = '';
  bool isButtonEnabled = true;

  // getMyDomain() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var savedDomainName = prefs.getString('domainname') ?? '';
  //   setState(() {
  //     mainHost = savedDomainName;
  //   });
  // }

  Future<void> initDiskSpacePlus() async {
    double diskSpace = 0;

    diskSpace = await DiskSpacePlus.getFreeDiskSpace ?? 0;

    setState(() {
      _diskSpace = diskSpace;
      if (_diskSpace < 2000.00) {
        setState(() {
          lowStorage = true;
        });
      } else {
        lowStorage = false;
      }
    });
  }

  @override
  void initState() {
    getToken();
    initDiskSpacePlus();
    _fetchParts();
    super.initState();
  }

  getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final json = preferences.getString('token');
    if (json == null || json.isEmpty) {
      redirectToSignIn();
    }
  }

  void redirectToSignIn() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SignIn(),
        ),
        (Route<dynamic> route) => false);
  }

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
      // print("image dowloaded successfully");
    } catch (e) {
      debugPrint(e.toString());
      // print("image failed to download");
    }
  }

  // checkImageExist() async {
  //   imgPathLocal = await imageExist(widget.bookInfo.title);
  // }

  _fetchParts() async {
    CallApi().getPublicData('bookchapter2/${widget.bookInfo.bookid}').then(
      (response) {
        setState(
          () {
            var results = json.decode(response.body);
            // print(results);
            parts = results['parts'] ?? [];
            // print(parts);
            chapters = results['chapters'] ?? [];
            // print(chapters);
            lessons = results['lessons'] ?? [];
            bookCoverUrl = results['bookcover'] ?? '';
            // print(bookCoverUrl);
            // print(lessons);
          },
        );
      },
    );
  }

  _downloadPdf() async {
    try {
      EasyLoading.show(status: "Preparing...");
      final Directory appDir = await getApplicationSupportDirectory();
      var imgPathLocal = "${appDir.path}/${widget.bookInfo.title}/cover_image";
      setState(() {
        _isLoading = true;
      });
      _isLoading = true;
      var exist = await fileExist(widget.bookInfo.title);
      if (exist) {
        EasyLoading.dismiss();
        saveCurrentBook(widget.bookInfo.title);
        navigateToMainNav(imgPathLocal);
      } else {
        final Directory appDirFolder =
            Directory("${appDir.path}/${widget.bookInfo.title}/");
        final Directory bookNewFolder =
            await appDirFolder.create(recursive: true);
        downloadImage(bookNewFolder.path, "cover_image", bookCoverUrl);

        if (parts.isNotEmpty) {
          for (var part in parts) {
            // print(part);
            final Directory partDirFolder =
                Directory("${bookNewFolder.path}${part['title']}/");
            final Directory newPart =
                await partDirFolder.create(recursive: true);
            if (chapters.isNotEmpty) {
              for (var chapter in chapters) {
                if (chapter['partid'] != null &&
                    chapter['partid'] == part['id']) {
                  final Directory chapDirFolder =
                      Directory("${newPart.path}${chapter['title']}/");
                  final Directory newChap =
                      await chapDirFolder.create(recursive: true);

                  List<Future<void>> futures = [];
                  if (lessons.isNotEmpty) {
                    for (var lesson in lessons) {
                      if (lesson['chapterid'] != null &&
                          lesson['chapterid'] == chapter['id']) {
                        if (lesson['path'] != null &&
                            lesson['path'].isNotEmpty) {
                          for (var lessonFileItem in lesson['path']) {
                            futures.add(
                              downloadPdFiles(
                                lessonFileItem['filepath'],
                                lessonFileItem['content'],
                                '${newChap.path}${lessonFileItem['content']}',
                              ),
                            );
                          }
                        }
                      }
                    }
                  }
                  await Future.wait(futures);
                }
              }
            }
          }
          EasyLoading.dismiss();
          saveCurrentBook(widget.bookInfo.title);
          navigateToMainNav("${bookNewFolder.path}cover_image");
        } else {
          if (chapters.isNotEmpty) {
            for (var chapter in chapters) {
              final Directory chapDirFolder =
                  Directory("${bookNewFolder.path}${chapter['title']}/");
              final Directory newChap =
                  await chapDirFolder.create(recursive: true);

              List<Future<void>> futures = [];
              if (lessons.isNotEmpty) {
                for (var lesson in lessons) {
                  if (lesson['chapterid'] != null &&
                      lesson['chapterid'] == chapter['id']) {
                    if (lesson['path'] != null && lesson['path'].isNotEmpty) {
                      for (var lessonFileItem in lesson['path']) {
                        futures.add(
                          downloadPdFiles(
                            lessonFileItem['filepath'],
                            lessonFileItem['content'],
                            '${newChap.path}${lessonFileItem['content']}',
                          ),
                        );
                      }
                    }
                  }
                }
              }
              await Future.wait(futures);
            }
            saveCurrentBook(widget.bookInfo.title);
            navigateToMainNav("${bookNewFolder.path}cover_image");
          } else {
            // print('chapters empty');
          }
        }
        EasyLoading.dismiss();
      }
    } catch (e) {
      // Handle the exception
      // print('Error occurred: $e');
      EasyLoading.showError('Error occurred: $e');
      // You can handle the error message or show a toast or any other error handling mechanism you prefer.
      // Example: showToast('An error occurred while downloading the PDF');
      // showToast is a custom function that shows a toast message using fluttertoast package or any other similar package.
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
    EasyLoading.dismiss();
    setState(() {
      isButtonEnabled = true;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyNav2(
          books: PdfTile(
              title: widget.bookInfo.title, path: path, isExpanded: false),
          path: '',
        ),
      ),
    );
  }

  Future<void> saveCurrentBook(bookName) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('currentBook', bookName);
  }

  Future<void> downloadPdFiles(
    String url,
    String filename,
    String bookFolderDir,
  ) async {
    String host = "$mainHost$url";
    var savePath = bookFolderDir;
    // print(savePath);
    var dio = Dio();
    dio.interceptors.add(LogInterceptor());
    try {
      // print("Downloading...");
      var response = await dio.get(
        host,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: const Duration(seconds: 300),
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Color(0xff500a34)),
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
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
                title: Row(
                  children: [
                    // const SizedBox(
                    //   width: 20,
                    // ),
                    // IconButton(
                    //   padding: EdgeInsets.zero,
                    //   constraints: const BoxConstraints(),
                    //   icon:
                    //       const Icon(Icons.arrow_back_ios, color: Colors.white),
                    //   onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    //       MaterialPageRoute(
                    //         builder: (context) => const MyNav(),
                    //       ),
                    //       (Route<dynamic> route) => false),
                    // ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    Expanded(
                      child: Text(
                        widget.bookInfo.title,
                        style: GoogleFonts.prompt(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
              body: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Container(
                      //   padding: const EdgeInsets.only(left: 0, right: 30),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       IconButton(
                      //         padding: EdgeInsets.zero,
                      //         constraints: const BoxConstraints(),
                      //         icon: const Icon(Icons.arrow_back_ios,
                      //             color: Color(0xff232324)),
                      //         onPressed: () =>
                      //             Navigator.of(context).pushAndRemoveUntil(
                      //                 MaterialPageRoute(
                      //                   builder: (context) => const MyNav(),
                      //                 ),
                      //                 (Route<dynamic> route) => false),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Material(
                            elevation: 0.0,
                            child: widget.bookInfo.picurl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl:
                                        '$mainHost${widget.bookInfo.picurl}',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      height: 200,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 8,
                                              blurRadius: 10,
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
                                        Container(
                                      height: 200,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 8,
                                              blurRadius: 10,
                                              offset: const Offset(0, 3))
                                        ],
                                        image: const DecorationImage(
                                          image: AssetImage("img/CK_logo.png"),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
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
                                Text(
                                  widget.bookInfo.title,
                                  style: GoogleFonts.prompt(
                                    textStyle: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 22),
                                  ),
                                ),
                                // TextWidget(
                                //   color: Colors.black87,
                                //   text: widget.bookInfo.title,
                                //   fontSize: 22,
                                // ),
                                const Divider(color: Colors.grey),
                                Text(
                                  "Author : CK Children's Publishing",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Divider(
                        endIndent: 20,
                        color: Color(0xFF7b8ea3),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            "Details",
                            style: GoogleFonts.prompt(
                              textStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          'This book is brought to you by CK Children\'s Publishing. Your Access to Visual Learning and Integration',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black54),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 20),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: isButtonEnabled
                                  ? () {
                                      if (lowStorage) {
                                        EasyLoading.showInfo(
                                            'low storage! \npls clean your phone!');
                                      } else {
                                        setState(() {
                                          isButtonEnabled = false;
                                        });
                                        _downloadPdf();
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: isButtonEnabled
                                      ? const Color.fromARGB(255, 156, 21, 102)
                                      : Colors.grey,
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
                              // child: const Text(
                              //   "View Book",
                              //   style: TextStyle(
                              //     fontSize: 20,
                              //   ),
                              // ),
                              child: Text(
                                "View Book",
                                style: GoogleFonts.prompt(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20),
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
        ),
      ),
    );
    // builder: EasyLoading.init(),
  }
}
