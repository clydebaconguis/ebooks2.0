// import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebooks/app_util.dart';
import 'package:ebooks/models/get_books_info.dart';
import 'package:ebooks/models/get_lessons.dart';
import 'package:ebooks/pages/nav_pdf.dart';
import 'package:ebooks/pdf_view/pdf_view.dart';
import 'package:flutter/material.dart';
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
  List<Lessons> lessons = [];
  // _storeBookId() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   localStorage.setInt('bookid', widget.bookInfo.bookid);
  // }

  @override
  void initState() {
    // _storeBookId();
    _fetchParts();
    super.initState();
  }

  // _checkBookIdStatus() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var bookid = localStorage.getInt('bookid');
  //   if (bookid != null) {
  //     setState(() {
  //       bookId = bookid;
  //     });
  //     _fetchParts();
  //   }
  // }

  _fetchParts() async {
    CallApi().getPublicData('bookchapter/${widget.bookInfo.bookid}').then(
      (response) {
        setState(
          () {
            Iterable list = json.decode(response.body);
            print(list);
            lessons = list.map((e) => Lessons.fromJson(e)).toList();
            // if (response.body != null) {
            //
            // } else {
            //   // If that call was not successful, throw an error.
            //   throw Exception('Failed to load post');
            // }
          },
        );
      },
    );
  }

  _fileExist() {}

  _downloadPdf() async {
    lessons.forEach((element) async {
      String filename = AppUtil().splitPath(element.path);
      String newFile = await AppUtil.downloadPdFiles(
          element.path, filename, widget.bookInfo.title);
      if (newFile == "success") {
        AppUtil().readFilesDir(widget.bookInfo.title);
      }
    });
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
                                imageUrl:
                                    'http://192.168.0.103/${widget.bookInfo.picurl}',
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
                  Row(
                    children: [
                      const TextWidget(
                        text: "Details",
                        fontSize: 30,
                      ),
                      Expanded(
                        child: Container(
                          child: Text('${widget.bookInfo.bookid}'),
                        ),
                      )
                    ],
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
                  GestureDetector(
                    onTap: () {
                      _downloadPdf();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyNav2(
                            path: '',
                            books: widget.bookInfo,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          const TextWidget(
                            text: "View Book",
                            fontSize: 20,
                          ),
                          Expanded(child: Container()),
                          const IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: null)
                        ],
                      ),
                    ),
                  ),
                  const Divider(color: Color(0xFF7b8ea3)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
