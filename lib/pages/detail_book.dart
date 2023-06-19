// import 'package:flutter/cupertino.dart';
import 'package:ebooks/models/get_books_info.dart';
import 'package:ebooks/pdf_view/pdf_view.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_app_backend/components/text_widget.dart';
// import 'package:flutter_app_backend/models/get_article_info.dart';

import '../components/text_widget.dart';
import 'all_books.dart';

class DetailBookPage extends StatefulWidget {
  final Books bookInfo;
  final int index;
  const DetailBookPage({Key? key, required this.bookInfo, required this.index})
      : super(key: key);

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
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
                              color: Color(0xFF363f93)),
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
                        child: Container(
                          height: 180,
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
                              image: const DecorationImage(
                                  image: NetworkImage(
                                      // "http://mark.dbestech.com/uploads/${widget.bookInfo.img}"
                                      "https://99designs-blog.imgix.net/blog/wp-content/uploads/2017/07/attachment_73599840-e1500060411553.png?auto=format&q=60&fit=max&w=930"),
                                  fit: BoxFit.fill)),
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
                              text: widget.bookInfo.title,
                              fontSize: 30,
                            ),
                            TextWidget(
                                text: "Author: ${widget.bookInfo.author}",
                                fontSize: 20,
                                color: const Color(0xFF7b8ea3)),
                            const Divider(color: Colors.grey),
                            TextWidget(
                                text: widget.bookInfo.description,
                                fontSize: 16,
                                color: const Color(0xFF7b8ea3)),
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.bookmarks_sharp,
                              color: Color(0xFF7b8ea3),
                              size: 40,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            TextWidget(text: "Bookself", fontSize: 20),
                          ],
                        )
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
                      Expanded(child: Container())
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 200,
                    child: TextWidget(
                        // text: widget.bookInfo.article_content,
                        text: widget.bookInfo.content,
                        fontSize: 16,
                        color: Colors.grey),
                  ),
                  const Divider(color: Color(0xFF7b8ea3)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PDFViewPage(),
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
