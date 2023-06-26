class Lessons {
  int id;
  // String title;
  String path;
  String chaptertitle;

  Lessons(this.id, this.path, this.chaptertitle);

  factory Lessons.fromJson(Map json) {
    var id = json['id'] ?? 0;
    var path = json['path'] ?? '';
    var chaptertitle = json['chaptertitle'] ?? '';

    return Lessons(id, path, chaptertitle);
  }

  Map toJson() {
    return {
      'id': id,
      'path': path,
      'chaptertitle': chaptertitle,
    };
  }
}
