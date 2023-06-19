import 'dart:convert';

// import 'package:flutter/cupertino.dart';
import 'package:ebooks/api/my_api.dart';
import 'package:ebooks/models/get_articles_info.dart';
import 'package:ebooks/models/get_books_info.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_app_backend/api/my_api.dart';
// import 'package:flutter_app_backend/components/text_widget.dart';
// import 'package:flutter_app_backend/models/get_article_info.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../components/text_widget.dart';
import 'article_page.dart';
import 'detail_book.dart';

class AllBooks extends StatefulWidget {
  const AllBooks({Key? key}) : super(key: key);

  @override
  State<AllBooks> createState() => _AllBooksState();
}

class _AllBooksState extends State<AllBooks> {
  var books = <Books>[];

  @override
  void initState() {
    _getArticles();
    super.initState();
  }

  _getArticles() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("user");

/*
    if(user!=null){
    var userInfo=jsonDecode(user);
      debugPrint(userInfo);
    }else{
      debugPrint("no info");
    }*/
    await _initData();
  }

  _initData() async {
    await CallApi().getPublicData("books").then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        books = list.map((model) => Books.fromJson(model)).toList();
      });
    });
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
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // IconButton(
                    //     padding: EdgeInsets.zero,
                    //     constraints: const BoxConstraints(),
                    //     icon: const Icon(Icons.arrow_back_ios,
                    //         color: Color(0xFF363f93)),
                    //     onPressed: () => Navigator.pop(context)),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.home_outlined,
                        color: Color(0xFF363f93),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllBooks(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: books.isEmpty
                      ? const CircularProgressIndicator()
                      : Column(
                          children: books.map(
                            (book) {
                              debugPrint(book.img.toString());
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
                                          color: Colors.orange,
                                          elevation: 10.0,
                                          shadowColor:
                                              Colors.grey.withOpacity(0.5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Container(
                                            height: 200,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              image: const DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    "https://99designs-blog.imgix.net/blog/wp-content/uploads/2017/07/attachment_73599840-e1500060411553.png?auto=format&q=60&fit=max&w=930"),
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
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                softWrap: true,
                                              ),
                                              const Divider(
                                                  color: Colors.black),
                                              TextWidget(
                                                  text:
                                                      "Author: ${book.author}",
                                                  fontSize: 14),
                                              const Divider(
                                                  color: Colors.black),
                                              Text(
                                                book.description,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                softWrap: true,
                                              ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
