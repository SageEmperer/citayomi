
class NovelDetailType {
  final String title;
  final String author;
  final String imageUrl;
  final String? rank;
  final double? rating;
  final String? status;
  final String? views;
  final String? chaptersCount;
  final List<String> genres;
  final String? description;
  final String? source;

  NovelDetailType({
    required this.title,
    required this.author,
    required this.imageUrl,
    this.rank,
    this.rating,
    this.status,
    this.views,
    this.chaptersCount,
    this.genres = const [],
    this.description,
    this.source,
  });
}