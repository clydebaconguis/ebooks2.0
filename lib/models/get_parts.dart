import 'get_lessons.dart';

class Parts {
  final int id;
  final String title;
  final List<Lessons> lesson;
  // final List<Lessons> lessons;

  Parts(
    this.id,
    this.title,
    this.lesson,
  );

  factory Parts.fromJson(Map<String, dynamic> resJs) {
    var ll = List.from(resJs['lessoncontent']);
    // print(ll);
    List<Lessons> lessonList = ll.map((i) => Lessons.fromJson(i)).toList();
    return Parts(resJs['id'], resJs['title'], lessonList);
  }

  Map toJson() {
    return {'id': id, 'title': title, 'lesson': lesson};
  }
}
