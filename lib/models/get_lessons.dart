class Lessons {
  int id;
  String lessontitle;
  String path;
  String chaptertitle;

  Lessons(this.id, this.lessontitle, this.path, this.chaptertitle);

  factory Lessons.fromJson(Map json) {
    var id = json['id'] ?? 0;
    var lessontitle = json['lessontitle'] ?? '';
    var path = json['path'] ?? '';
    var chaptertitle = json['chaptertitle'] ?? '';

    return Lessons(id, lessontitle, path, chaptertitle);
  }

  Map toJson() {
    return {
      'id': id,
      'lessontitle': lessontitle,
      'path': path,
      'chaptertitle': chaptertitle,
    };
  }
}
