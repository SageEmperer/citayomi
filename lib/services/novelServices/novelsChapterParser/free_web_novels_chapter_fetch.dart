

import 'package:citayomi/models/NovelsModal/novelChaptersCache.dart';
import 'package:citayomi/models/NovelsModal/novelChaptersModal.dart';
import 'package:citayomi/models/NovelsModal/novelLibraryModal.dart';
import 'package:citayomi/services/novelServices/novelsSaving/novel_detail_save.dart';
import 'package:citayomi/services/novelServices/novels_library_fetch.dart';
import 'package:citayomi/types/NovelChaptersType.dart';

import 'package:http/http.dart'
    as http;

import 'package:html/parser.dart'
    as parser;

import 'package:html/dom.dart'
    as dom;



Future<List<NovelChaptersModal>>
    fetchFreeWebNovelsChapters$(
  String keyId,
  String novelUrl,
) async {
  

  try {
    final NovelLibraryModal? novelData =
        fetchNovelLibraryItem(keyId);

    if (novelData == null) {
      return [];
    }

    final baseUrl = novelData.webUrl;
    final url = '$baseUrl/novel/$novelUrl';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      },
    );

    if (response.statusCode != 200) {
      return [];
    }

    final document = parser.parse(
      response.body,
    );

    final chapterItems =
        document.querySelectorAll(
      'ul#idData.ul-list5 li',
    );

    final regex = RegExp(
      r'^Chapter\s+(\d+)(?:\s*:\s*|\s+)(.*)$',
      caseSensitive: false,
    );

    final List<NovelChaptersModal>
        chapters = [];

    for (final item in chapterItems) {
      final anchor =
          item.querySelector('a');

      if (anchor == null) {
        continue;
      }

      final chapterText =
          anchor.text.trim();

      final chapterHref =
          anchor.attributes['href'] ??
              '';

      final match = regex.firstMatch(
        chapterText,
      );

      if (match == null) {
        continue;
      }

      chapters.add(
        NovelChaptersModal(
          keyId: keyId,
          novelUrl: novelUrl,
          chapterUrl: chapterHref,
          chapterNumber: match.group(1)!.trim(),
          chapterTitle:
              match.group(2)!.trim(),
        ),
      );
    }
    final cache = NovelChaptersCache(
      keyId: keyId,
      novelUrl: novelUrl,
      chapters: chapters,
    );
    NovelsHiveHelper.saveNovelChapters(keyId, novelUrl, chapters);
    return  cache.chapters;
  } catch (e) {
    print(
      'fetchFreeWebNovelsChapters\$ error: $e',
    );

    return [];
  }
}