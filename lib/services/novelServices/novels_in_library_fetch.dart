import 'package:citayomi/models/NovelsModal/novelChaptersCache.dart';
import 'package:citayomi/models/NovelsModal/novelChaptersModal.dart';
import 'package:citayomi/models/NovelsModal/novelDetailModal.dart';
import 'package:citayomi/services/novelServices/novelDetailParser/free_web_novel_detail_parse.dart';
import 'package:citayomi/services/novelServices/novelDetailParser/novel_fire_novel_detail_parse.dart';
import 'package:citayomi/services/novelServices/novelsChapterParser/free_web_novels_chapter_fetch.dart';
import 'package:citayomi/services/novelServices/novelsLibraryParser/free_web_novels_library_fetch.dart';
import 'package:citayomi/services/novelServices/novelsLibraryParser/novel_fire_parse.dart';
import 'package:citayomi/services/novelServices/novelsSaving/novel_detail_save.dart';
import 'package:citayomi/types/NovelChaptersType.dart';
import 'package:citayomi/types/NovelDetailType.dart';

class NovelScraper {

  static Future<List<Map<String, dynamic>>>
      scrapeNovels(String keyId, int page , {String filter = ""}) async {

    try {
      print("page $page");
      if (keyId.isEmpty) {
        return [];
      }

      if (keyId == "firenovel") {
        return await fetchFireNovels$(
          keyId,
          page,
        );
      }

      if (keyId == "freewebnovel") {
        return await fetchFreeWebNovels$(
          keyId,
          page,
          filter: filter,
        );
      }

      return [];

    } catch (e) {

      print(
        'NovelScraper Error: $e',
      );

      return [];
    }
  }

  static Future<NovelDetailModal?> scrapeNovelDetail(String keyId, String novelUrl, {bool foreceRefresh = false}) async {
    try {
      if (!foreceRefresh) {
        final NovelDetailModal? novelDetail = await NovelsHiveHelper.getNovelDetail(keyId, novelUrl) as NovelDetailModal?;
        if (novelDetail != null) {
          
          return novelDetail;
        }
      }
      if (keyId.isEmpty) {
        return null;
      }

      if (keyId == "firenovel") {
        return await fetchFireNovelDetail$(
          keyId,
          novelUrl,
        );
      }
      if (keyId == "freewebnovel") {
        return await fetchFreeWebNovelDetail$(
          keyId,
          novelUrl,
        );
      }

      return null;

    } catch (e) {

      print(
        'NovelDetailScraper Error: $e',
      );

      return null;
    }
  }
  
  static Future<List<NovelChaptersModal>> scrapeNovelChapters(String keyId, String novelUrl, {bool foreceRefresh = false}) async {
    try {
      if (keyId.isEmpty) {
        return [];
      }
      if (!foreceRefresh) {
        final cache =
            await NovelsHiveHelper.getNovelChapters(
              keyId,
              novelUrl,
            );

        if (cache != null) {
          return cache.chapters;
        }
      }

      if (keyId == "firenovel") {
        // return await fetchFireNovelChapters$(
        //   keyId,
        //   novelUrl,
        // );
        return [];
      }
      if (keyId == "freewebnovel") {
        return await fetchFreeWebNovelsChapters$(
          keyId,
          novelUrl,
        );
      }

      return [];

    } catch (e) {

      print(
        'NovelDetailScraper Error: $e',
      );

      return [];
    }
  }

}