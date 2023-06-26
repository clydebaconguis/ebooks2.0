import 'package:flutter/services.dart';

class Books2 {
  int bookid;
  String title;
  String picurl;
  String createddatetime;

  Books2(this.bookid, this.title, this.picurl, this.createddatetime);

  factory Books2.fromJson(Map json) {
    var pic = json['picurl'] ?? '';
    var created = json['createddatetime'] ?? '';

    return Books2(json['bookid'], json['title'], pic, created);
  }

  Map toJson() {
    return {
      'bookid': bookid,
      'title': title,
      'picurl': picurl,
      'createddatetime': createddatetime,
    };
  }
}
