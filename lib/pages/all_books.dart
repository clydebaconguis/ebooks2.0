import 'dart:convert';
import 'dart:io';
import 'package:ebooks/api/my_api.dart';
import 'package:ebooks/app_util.dart';
import 'package:ebooks/pages/nav_pdf.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/text_widget.dart';
import '../models/get_books_info_02.dart';
import '../models/pdf_tile.dart';
import 'detail_book.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AllBooks extends StatefulWidget {
  const AllBooks({Key? key}) : super(key: key);

  @override
  State<AllBooks> createState() => _AllBooksState();
}

class _AllBooksState extends State<AllBooks> {
  late ConnectivityResult _connectivityResult = ConnectivityResult.none;
  final String host = CallApi().getHost();
  var books = <Books2>[];
  List<PdfTile> files = [];
  bool reloaded = false;
  bool activeConnection = true;
  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
          getBooksOnline();
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        getDownloadedBooks();
      });
    }
    // displayScreeMsg();
  }

  displayScreeMsg() {
    if (!reloaded) {
      if (activeConnection) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Connection restored."),
          backgroundColor: Colors.pink,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Offline Mode."),
          backgroundColor: Colors.pink,
        ));
      }
    }
  }

  @override
  void initState() {
    checkConnectivity();
    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectivityResult = result;
        if (_connectivityResult.toString() == "ConnectivityResult.mobile" ||
            _connectivityResult.toString() == "ConnectivityResult.wifi") {
          setState(() {
            reloaded = true;
            activeConnection = true;
            getBooksOnline();
          });
        } else {
          setState(() {
            reloaded = true;
            activeConnection = false;
            getDownloadedBooks();
          });
        }
        displayScreeMsg();
      });
    });
    // checkUserConnection();
    readSpecificBook();
    super.initState();
  }

  Future<void> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = connectivityResult;
      if (_connectivityResult.toString() == "ConnectivityResult.mobile" ||
          _connectivityResult.toString() == "ConnectivityResult.wifi") {
        setState(() {
          reloaded = true;
          activeConnection = true;
          getBooksOnline();
        });
      } else {
        setState(() {
          reloaded = true;
          activeConnection = false;
          getDownloadedBooks();
        });
      }
      displayScreeMsg();
    });
  }

  readSpecificBook() async {
    var dir = await getApplicationSupportDirectory();
    // final pathFile = Directory(dir.path);
    final pathFile = Directory(
        '${dir.path}/Visual Graphics Design Okey/1 INTRODUCTION TO COMPUTER IMAGES AND ADOBE PHOTOSHOP/Chapter 2: Getting Started in Photoshop');
    final List<FileSystemEntity> entities = await pathFile.list().toList();
    final Iterable<Directory> files = entities.whereType<Directory>();
    // pathFile.deleteSync(recursive: true);
    for (var element in entities) {
      print(element.path);
    }
    // print(entities);
  }

  getDownloadedBooks() async {
    books.clear();
    files.clear();
    var result = await AppUtil().readBooks();
    late String imgUrl = '';
    final List<PdfTile> listOfChild = [];
    listOfChild.clear();
    result.forEach(
      (item) async {
        // print(item);
        var foldrName = splitPath(item.path);
        var foldrChild = await AppUtil().readFilesDir(foldrName);
        if (foldrChild.isNotEmpty) {
          foldrChild.forEach((element) {
            // print(element);
            if (splitPath(element.path).toString() == "cover_image") {
              imgUrl = element.path;
            }
            if (element.path.isNotEmpty &&
                splitPath(element.path).toString() != "cover_image") {
              listOfChild.add(
                PdfTile(
                    title: splitPath(element.path),
                    path: element.path,
                    isExpanded: false),
              );
            }
          });
        }
        setState(
          () {
            files.add(
              PdfTile(
                  title: foldrName,
                  path: imgUrl,
                  children: listOfChild,
                  isExpanded: false),
            );
          },
        );
        imgUrl = '';
        listOfChild.clear();
      },
    );
  }

  // bool isImage(String path) {
  //   final mimeType = lookupMimeType(path);
  //   return mimeType!.startsWith('image/');
  // }

  getBooksOnline() async {
    files.clear();
    books.clear();
    await CallApi().getPublicData("viewbook").then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        // print(list);
        books = list.map((model) => Books2.fromJson(model)).toList();
      });
    });
  }

  String splitPath(url) {
    File file = File(url);
    String filename = file.path.split(Platform.pathSeparator).last;
    return filename;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // _connectivityResult.toString() == "ConnectivityResult.mobile"
              //     ? const Text(
              //         "MOBILE",
              //       )
              //     : const Text(
              //         "WIFI",
              //       ),
              // SizedBox(
              //   height: height * 0.02,
              // ),
              // Container(
              //   padding: const EdgeInsets.only(left: 20, right: 20),
              //   // child: Row(
              //   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   //   children: [
              //   //     // IconButton(
              //   //     //     padding: EdgeInsets.zero,
              //   //     //     constraints: const BoxConstraints(),
              //   //     //     icon: const Icon(Icons.arrow_back_ios,
              //   //     //         color: Color(0xFF363f93)),
              //   //     //     onPressed: () => Navigator.pop(context)),
              //   //     // IconButton(
              //   //     //   padding: EdgeInsets.zero,
              //   //     //   constraints: const BoxConstraints(),
              //   //     //   icon: const Icon(
              //   //     //     Icons.home_outlined,
              //   //     //     color: Color(0xff232324),
              //   //     //   ),
              //   //     //   onPressed: () => Navigator.push(
              //   //     //     context,
              //   //     //     MaterialPageRoute(
              //   //     //       builder: (context) => const AllBooks(),
              //   //     //     ),
              //   //     //   ),
              //   //     // ),
              //   //   ],
              //   // ),
              // ),
              // const SizedBox(
              //   height: 15,
              // ),

              Expanded(
                child: (files.isNotEmpty && !activeConnection)
                    ? SingleChildScrollView(
                        child: Column(
                        children: files.asMap().keys.toList().map(
                          (
                            index,
                          ) {
                            var file = files[index];
                            debugPrint(file.path.toString());
                            return GestureDetector(
                              onTap: () {
                                saveCurrentBook(file.title);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyNav2(
                                      books: file,
                                      path: '',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                height: 250,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 35,
                                      child: Material(
                                        elevation: 0.0,
                                        child: Container(
                                          height: 180.0,
                                          width: width * 0.9,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                offset: const Offset(0.0, 0.0),
                                                blurRadius: 20.0,
                                                spreadRadius: 4.0,
                                              )
                                            ],
                                          ),
                                          // child: Text("This is where your content goes")
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 10,
                                      child: Card(
                                        color: Colors.transparent,
                                        elevation: 10.0,
                                        shadowColor:
                                            Colors.grey.withOpacity(0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: file.path.isNotEmpty
                                            ? Container(
                                                height: 200,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  image: DecorationImage(
                                                    image: FileImage(
                                                        File(file.path)),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 200,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  image: const DecorationImage(
                                                    image: AssetImage(
                                                        "img/CK_logo.png"),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 45,
                                      left: width * 0.5,
                                      child: SizedBox(
                                        height: 180,
                                        width: 150,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              file.title,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff292735),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              softWrap: true,
                                            ),
                                            const Divider(color: Colors.black),
                                            const ListTile(
                                              contentPadding:
                                                  EdgeInsets.only(left: 0),
                                              horizontalTitleGap: 0,
                                              minVerticalPadding: 0,
                                              minLeadingWidth: 0,
                                              leading: Icon(
                                                Icons.download_done_rounded,
                                                color: Colors.green,
                                                textDirection:
                                                    TextDirection.ltr,
                                              ),
                                              title: TextWidget(
                                                  color: Colors.grey,
                                                  text: "Downloaded",
                                                  fontSize: 14),
                                            ),
                                            const Divider(color: Colors.grey),
                                            // Text(
                                            //   book.description,
                                            //   style: const TextStyle(
                                            //       fontWeight: FontWeight.bold,
                                            //       color: Colors.grey,
                                            //       fontSize: 14),
                                            //   overflow: TextOverflow.ellipsis,
                                            //   maxLines: 2,
                                            //   softWrap: true,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ))
                    : SingleChildScrollView(
                        child: Column(
                          children: books.map(
                            (book) {
                              debugPrint(book.picurl.toString());
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailBookPage(
                                          bookInfo: book, index: 0),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  height: 250,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 35,
                                        child: Material(
                                          elevation: 0.0,
                                          child: Container(
                                            height: 180.0,
                                            width: width * 0.9,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  offset:
                                                      const Offset(0.0, 0.0),
                                                  blurRadius: 20.0,
                                                  spreadRadius: 4.0,
                                                )
                                              ],
                                            ),
                                            // child: Text("This is where your content goes")
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        left: 10,
                                        child: Card(
                                          color: Colors.transparent,
                                          elevation: 10.0,
                                          shadowColor:
                                              Colors.grey.withOpacity(0.5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: book.picurl.isNotEmpty
                                              ? CachedNetworkImage(
                                                  imageUrl:
                                                      "$host${book.picurl}",
                                                  // "https://drive.google.com/uc?export=view&id=${book.img}",
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    height: 200,
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                )
                                              : Container(
                                                  height: 200,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    image:
                                                        const DecorationImage(
                                                      image: AssetImage(
                                                          "img/CK_logo.png"),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 45,
                                        left: width * 0.5,
                                        child: SizedBox(
                                          height: 180,
                                          width: 150,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                book.title,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff292735),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                softWrap: true,
                                              ),
                                              const Divider(
                                                  color: Colors.black),
                                              const TextWidget(
                                                  color: Color(0xcd292735),
                                                  text:
                                                      "Author: CK Children's Publishing",
                                                  fontSize: 14),
                                              const Divider(color: Colors.grey),
                                              // Text(
                                              //   book.description,
                                              //   style: const TextStyle(
                                              //       fontWeight: FontWeight.bold,
                                              //       color: Colors.grey,
                                              //       fontSize: 14),
                                              //   overflow: TextOverflow.ellipsis,
                                              //   maxLines: 2,
                                              //   softWrap: true,
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveCurrentBook(bookName) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('currentBook', bookName);
  }
}
