class Lessons {
  int id;
  String title;
  String path;
  String chaptertitle;

  Lessons(this.id, this.title, this.path, this.chaptertitle);

  // Lessons.fromJson(Map json)
  //     : id = json['id'],
  //       title = json['title'],
  //       path = json['path'],
  //       chaptertitle = json['chaptertitle'];

  factory Lessons.fromJson(Map json) {
    var id = json['id'] ?? 0;
    var title = json['title'] ?? '';
    var path = json['path'] ?? '';
    var chaptertitle = json['chaptertitle'] ?? '';

    return Lessons(id, title, path, chaptertitle);
  }

  Map toJson() {
    return {
      'id': id,
      'title': title,
      'path': path,
      'chaptertitle': chaptertitle,
    };
  }
}
