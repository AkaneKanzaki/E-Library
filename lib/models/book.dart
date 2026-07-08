class Book {
  final String id;
  final String title;
  final String author;
  final String publisher;
  final String publishYear;
  final String description;
  final String coverUrl;
  final bool isAvailable;
  final String category;
  final String bookPath;
  final int pageCount;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.publisher,
    required this.publishYear,
    required this.description,
    required this.coverUrl,
    required this.isAvailable,
    required this.category,
    required this.bookPath,
    required this.pageCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'publisher': publisher,
      'publishYear': publishYear,
      'description': description,
      'coverUrl': coverUrl,
      'isAvailable': isAvailable ? 1 : 0,
      'category': category,
      'bookPath': bookPath,
      'pageCount': pageCount,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      publisher: map['publisher'] ?? '',
      publishYear: map['publishYear'] ?? '',
      description: map['description'] ?? '',
      coverUrl: map['coverUrl'] ?? '',
      isAvailable: map['isAvailable'] == 1,
      category: map['category'] ?? '',
      bookPath: map['bookPath'] ?? '',
      pageCount: map['pageCount'] ?? 0,
    );
  }
}