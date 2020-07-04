class News {
  Source _source;
  String _title;
  String _author;
  String _content;
  String _imageUrl;
  String _publishedAt;


  News(this._source,  this._title, this._author, this._content, this._imageUrl,
      this._publishedAt);
  //Criar um método fábrica (factory) para converter o json em objeto Dart
  factory News.fromJson(Map<String, dynamic> json){
    return News(
      Source.fromJson(json["source"]),
      json["title"],
      json["author"],
      json["content"],
      json["urlToImage"],
      json["publishedAt"]
    );
  }
  Source get source => _source;

  String get title => _title;

  String get author => _author;


  String get publishedAt => _publishedAt;

  String get imageUrl => _imageUrl;

  String get content => _content;
}

class Source{
  String _id;
  String _name;

  String get id => _id;

  Source(this._id, this._name);

  //Criar um método fábrica (factory) para converter o json em objeto Dart
  factory Source.fromJson(Map<String, dynamic> json){
    return Source(
      json["id"],
      json["name"]
    );
  }

  String get name => _name;

}