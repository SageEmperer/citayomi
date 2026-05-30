import 'package:citayomi/services/novelServices/novelDetailParser/novel_fire_novel_detail_parse.dart';
import 'package:citayomi/services/novelServices/novelsLibraryParser/novel_fire_parse.dart';
import 'package:citayomi/types/NovelDetailType.dart';

class NovelScraper {

  static Future<List<Map<String, dynamic>>>
      scrapeNovels(String keyId, int page) async {

    try {

      if (keyId.isEmpty) {
        return [];
      }

      if (keyId == "firenovel") {
        return await fetchFireNovels$(
          keyId,
          page,
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

  static Future<NovelDetailType?> scrapeNovelDetail(String keyId, String novelUrl) async {
    try {
      if (keyId.isEmpty) {
        return null;
      }

      if (keyId == "firenovel") {
        print("called function ");
        print(keyId);
        print(novelUrl);
        return await fetchFireNovelDetail$(
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
}