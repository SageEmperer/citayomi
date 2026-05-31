
class NovelDetailType {
  final String keyId;
  final String title;
  final String author;
  final String imageUrl;
  final String? rank;
  final double? rating;
  final String? status;
  final String? views;
  final String? chaptersCount;
  final List<String> genres;
  final List<String> description;
  final String? source;
  final String novelUrl;
  final List<Map<String, dynamic>> chapterList;

  NovelDetailType({
    this.keyId = "",
    required this.title,
    required this.author,
    required this.imageUrl,
    this.rank,
    this.rating,
    this.status,
    this.views,
    this.chaptersCount,
    this.genres = const [],
    this.description = const [],
    this.source,
    required this.novelUrl,
    this.chapterList = const [],
  });
}