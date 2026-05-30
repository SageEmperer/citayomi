class NovelItemType {
  final String title;
  final String novelUrl;
  final String imageUrl;
  final String ? rank;
  final String ? rating;

   NovelItemType({
    required this.title,
    required this.novelUrl,
    required this.imageUrl,
    this.rank,
    this.rating,
   });
}
