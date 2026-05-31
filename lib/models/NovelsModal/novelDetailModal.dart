import 'dart:convert';

import 'package:citayomi/types/NovelDetailType.dart';
import 'package:hive/hive.dart';

part 'novelDetailModal.g.dart';

@HiveType(typeId: 2)
class NovelDetailModal extends HiveObject {
  @HiveField(0)
  String keyId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String author;

  @HiveField(3)
  String imageUrl;

  @HiveField(4)
  String? rank;

  @HiveField(5)
  double? rating;

  @HiveField(6)
  String? status;

  @HiveField(7)
  String? views;

  @HiveField(8)
  String? chaptersCount;

  @HiveField(9)
  List<String> genres;

  @HiveField(10)
  List<String> description;

  @HiveField(11)
  String? source;

  @HiveField(12)
  String novelUrl;


  NovelDetailModal({
    required this.keyId,
    required this.title,
    required this.author,
    required this.imageUrl,
    this.novelUrl = "",
    this.rank,
    this.rating,
    this.status,
    this.views,
    this.chaptersCount,
    this.genres = const [],
    this.description = const [],
    this.source,
  });

  factory NovelDetailModal.fromType(
    NovelDetailType novel,
  ) {
    return NovelDetailModal(
      keyId: novel.keyId,
      title: novel.title,
      author: novel.author,
      imageUrl: novel.imageUrl,
      rank: novel.rank,
      rating: novel.rating,
      status: novel.status,
      views: novel.views,
      chaptersCount: novel.chaptersCount,
      genres: novel.genres,
      description: novel.description,
      source: novel.source,
      novelUrl: novel.novelUrl,
      
    );
  }

  NovelDetailType toType() {
    return NovelDetailType(
      keyId: keyId,
      title: title,
      author: author,
      imageUrl: imageUrl,
      rank: rank,
      rating: rating,
      status: status,
      views: views,
      chaptersCount: chaptersCount,
      genres: genres,
      description: description,
      source: source,
      novelUrl: novelUrl,
    );
  }
}