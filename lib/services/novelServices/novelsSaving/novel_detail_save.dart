import 'package:citayomi/models/NovelsModal/novelChaptersCache.dart';
import 'package:citayomi/models/NovelsModal/novelChaptersModal.dart';
import 'package:citayomi/models/NovelsModal/novelDetailModal.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NovelsHiveHelper {
  static const String _boxName = 'novelDetail';

  static const String _chapterBoxName = 'novelChaptersCache';

  static Future<NovelDetailModal?> getNovelDetail(
    String keyId,
    String novelUrl,
  ) async {
    final box =
        await Hive.openBox<NovelDetailModal>(
      _boxName,
    );
    return box.get('$keyId-$novelUrl');
  }

  static Future<void> saveNovelDetail(
    NovelDetailModal novelDetail,
  ) async {
    final box =
        await Hive.openBox<NovelDetailModal>(
      _boxName,
    );
    await box.put(
      '${novelDetail.keyId}-${novelDetail.novelUrl}',
      novelDetail,
    );
  }


  // ================== novel chapters ==================
static Future<NovelChaptersCache?> getNovelChapters(
  String keyId,
  String novelUrl,
) async {
  final box =
      await Hive.openBox<NovelChaptersCache>(
    _chapterBoxName,
  );
  print("gettcalleedeedddddddddddddddddddddddddddddddd");
  print("$keyId-$novelUrl");
  print(box.values.toList());
  return box.get('$keyId-$novelUrl');
}

static Future<void> saveNovelChapters(
  String keyId,
  String novelUrl,
  List<NovelChaptersModal> chapters,
) async {
  final box =
      await Hive.openBox<NovelChaptersCache>(
    _chapterBoxName,
  );

  await box.put(
    '$keyId-$novelUrl',
    NovelChaptersCache(
      keyId: keyId,
      novelUrl: novelUrl,
      chapters: chapters,
    ),
  );
}

}