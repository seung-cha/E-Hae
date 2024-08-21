class BookMetadata {
  final double width;
  final double height;
  final String id;
  final int pageCount;

  BookMetadata(this.id, this.pageCount, this.width, this.height);
  BookMetadata.fromJson(Map<String, dynamic> json)
      : width = json['width'] as double,
        height = json['height'] as double,
        id = json['id'] as String,
        pageCount = json['pageCount'] as int;
}
