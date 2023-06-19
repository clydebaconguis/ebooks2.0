class Books {
  int id;
  String title;
  String description;
  String createdAt;
  String content;
  String img;
  String author;

  Books(this.img, this.id, this.title, this.content, this.description,
      this.createdAt, this.author);

  Books.fromJson(Map json)
      : id = json['id'],
        author = json['author'],
        description = json['description'],
        title = json['title'],
        content = json['content'],
        createdAt = json['created_at'],
        img = json['img'];
  Map toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'createdAt': createdAt,
      'img': img,
      'author': author,
    };
  }
}
