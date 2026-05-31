import 'dart:convert';

import 'package:citayomi/models/NovelsModal/novelChaptersModal.dart';
import 'package:citayomi/types/NovelChaptersType.dart';
import 'package:hive/hive.dart';

part 'novelChaptersCache.g.dart';

@HiveType(typeId: 4)
class NovelChaptersCache extends HiveObject {
  @HiveField(0)
  String keyId;

  @HiveField(1)
  String novelUrl;

  @HiveField(2)
  List<NovelChaptersModal> chapters;

  NovelChaptersCache({
    required this.keyId,
    required this.novelUrl,
    required this.chapters,
  });
}