import 'dart:convert';

import 'package:citayomi/types/NovelChaptersType.dart';
import 'package:hive/hive.dart';

part 'novelChaptersModal.g.dart';

@HiveType(typeId: 3)
class NovelChaptersModal extends HiveObject {
  @HiveField(0)
  String keyId;

  @HiveField(1)
  String novelUrl;

  @HiveField(2)
  String chapterUrl;

  @HiveField(3)
  String chapterTitle;

  @HiveField(4)
  String chapterNumber;

  NovelChaptersModal({
    required this.keyId,
    required this.novelUrl,
    required this.chapterUrl,
    required this.chapterTitle,
    required this.chapterNumber,
  });

  factory NovelChaptersModal.fromType(
    NovelChaptersType novel,
  ) {
    return NovelChaptersModal(
      keyId: novel.keyId,
      novelUrl: novel.novelUrl,
      chapterUrl: novel.chapterUrl,
      chapterTitle: novel.chapterTitle,
      chapterNumber: novel.chapterNumber,
    );
  }

  NovelChaptersType toType() {
    return NovelChaptersType(
      keyId: keyId,
      novelUrl: novelUrl,
      chapterUrl: chapterUrl,
      chapterTitle: chapterTitle,
      chapterNumber: chapterNumber,
    );
  }
}