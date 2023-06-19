class ArticleInfo {
  int id;
  String img;
  String title;
  String author;
  String createdAt;
  String description;
  String articleContent;

  ArticleInfo(this.img, this.id, this.articleContent, this.title,
      this.description, this.createdAt, this.author);

  ArticleInfo.fromJson(Map json)
      : id = json['id'],
        author = json['author'],
        articleContent = json['article_content'],
        description = json['description'],
        title = json['title'],
        createdAt = json['created_at'],
        img = json['img'];

  Map toJson() {
    return {
      'id': id,
      'article_content': articleContent,
      'title': title,
      'description': description,
      'created_at': createdAt,
      'img': img,
      'author': author,
    };
  }
}
