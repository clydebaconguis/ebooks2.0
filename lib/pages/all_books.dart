import 'dart:convert';
import 'dart:io';
import 'package:ebooks/api/my_api.dart';
import 'package:ebooks/app_util.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../components/text_widget.dart';
import '../models/get_books_info_02.dart';
import '../models/pdf_tile.dart';
import 'detail_book.dart';
import 'package:mime/mime.dart';

class AllBooks extends StatefulWidget {
  const AllBooks({Key? key}) : super(key: key);

  @override
  State<AllBooks> createState() => _AllBooksState();
}

class _AllBooksState extends State<AllBooks> {
  var books = <Books2>[];
  List<PdfTile> files = [];
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Offline Mode."),
          backgroundColor: Colors.pink,
        ));
      });
    }
  }

  @override
  void initState() {
    checkUserConnection();
    super.initState();
  }

  getDownloadedBooks() async {
    books.clear();
    files.clear();
    var result = await AppUtil().readBooks();
    String imgUrl = '';
    final List<PdfTile> listOfChild = [];
    result.forEach(
      (item) async {
        print(item);
        var foldrName = splitPath(item.path);
        var foldrChild = await AppUtil().readFilesDir(foldrName);

        if (foldrChild.isNotEmpty) {
          foldrChild.forEach((element) {
            print(element);
            if (isImage(element.path)) {
              imgUrl = element.path;
            }
            listOfChild.add(
              PdfTile(title: splitPath(element.path), path: element.path),
            );
          });
          setState(
            () {
              files.add(
                PdfTile(title: foldrName, path: imgUrl, lessons: listOfChild),
              );
            },
          );
        }
      },
    );
  }

  bool isImage(String path) {
    final mimeType = lookupMimeType(path);
    return mimeType!.startsWith('image/');
  }

  getBooksOnline() async {
    books.clear();
    files.clear();
    await CallApi().getPublicData("viewbook").then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print(list);
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.02,
              ),
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
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: books.isNotEmpty && files.isEmpty
                        ? Column(
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
                                                        "http://192.168.0.103/${book.picurl}",
                                                    // "https://drive.google.com/uc?export=view&id=${book.img}",
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      height: 200,
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                    placeholder:
                                                        (context, url) =>
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  softWrap: true,
                                                ),
                                                const Divider(
                                                    color: Colors.black),
                                                TextWidget(
                                                    color:
                                                        const Color(0xcd292735),
                                                    text:
                                                        "publish: ${book.createddatetime}",
                                                    fontSize: 14),
                                                const Divider(
                                                    color: Colors.grey),
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
                          )
                        : files.isNotEmpty && books.isEmpty
                            ? Column(
                                children: files.map(
                                  (file) {
                                    debugPrint(file.path.toString());
                                    return GestureDetector(
                                      onTap: () {
                                        // Navigator.push(
                                        // context,
                                        // MaterialPageRoute(
                                        //   builder: (context) =>
                                        //       DetailBookPage(
                                        //           bookInfo: file, index: 0),
                                        // ),
                                        // );
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
                                                        BorderRadius.circular(
                                                            0.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        offset: const Offset(
                                                            0.0, 0.0),
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
                                                shadowColor: Colors.grey
                                                    .withOpacity(0.5),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child: file.path.isNotEmpty
                                                    ? Container(
                                                        height: 200,
                                                        width: 150,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          image:
                                                              DecorationImage(
                                                            image: FileImage(
                                                                File(
                                                                    file.path)),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 200,
                                                        width: 150,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                                      file.title,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff292735),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                      softWrap: true,
                                                    ),
                                                    const Divider(
                                                        color: Colors.black),
                                                    const TextWidget(
                                                        color:
                                                            Color(0xcd292735),
                                                        text:
                                                            "publish: sample123",
                                                        fontSize: 14),
                                                    const Divider(
                                                        color: Colors.grey),
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
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
