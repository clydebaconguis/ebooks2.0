// import 'dart:convert';
// import 'dart:ui';

// import 'package:ebooks/models/get_chapters.dart';
// import 'package:ebooks/models/get_parts.dart';

// import 'get_lessons.dart';
// import 'get_part.dart';

// class DirFields {
//   final List<dynamic> parts;
//   final List<dynamic> chapters;
//   final List<dynamic> lessons;
//   // final List<Lessons> lessons;

//   DirFields(
//     this.parts,
//     this.chapters,
//     this.lessons,
//   );

//   factory DirFields.fromJson(Map<String, dynamic> resJs) {
//     var ll = List.from(resJs['lessoncontent']);
//     print(ll);
//     List<Lessons> lessonList = ll.map((i) => Lessons.fromJson(i)).toList();
//     return DirFields(resJs['id'], resJs['title'], lessonList);
//   }

//   Map toJson() {
//     return {'id': parts, 'title': title, 'lesson': lesson};
//   }
// }
