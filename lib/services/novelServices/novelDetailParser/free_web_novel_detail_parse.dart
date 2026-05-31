


import 'package:citayomi/models/NovelsModal/novelDetailModal.dart';
import 'package:citayomi/models/NovelsModal/novelLibraryModal.dart';
import 'package:citayomi/services/novelServices/novelsSaving/novel_detail_save.dart';
import 'package:citayomi/services/novelServices/novels_library_fetch.dart';
import 'package:citayomi/types/NovelDetailType.dart';

import 'package:http/http.dart'
    as http;

import 'package:html/parser.dart'
    as parser;

import 'package:html/dom.dart'
    as dom;


Future<NovelDetailModal?> fetchFreeWebNovelDetail$(
  String keyId,
  String novelUrl,
) async {
  try {
    final NovelLibraryModal? novelData =
        fetchNovelLibraryItem(keyId);

    if (novelData == null) {
      return null;
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
      print("invalid respoinse");
      return null;
    }

    final document = parser.parse(
      response.body,
    );

    final novelHeader =
        document.querySelector(
      '.m-book1',
    );
    print("novelHeader: $novelHeader");

    if (novelHeader == null) {
      return null;
    }

    // TITLE

    final title =
        novelHeader
            .querySelector(
              'h1.tit',
            )
            ?.text
            .trim() ??
        'Unknown Title';

    // COVER IMAGE

    String imageUrl =
        novelHeader
            .querySelector(
              '.pic img',
            )
            ?.attributes['src'] ??
        '';

    if (imageUrl.isNotEmpty &&
        imageUrl.startsWith('/')) {
      imageUrl = '$baseUrl$imageUrl';
    }

    // AUTHOR

    final author =
        novelHeader
            .querySelector(
              '.item .right a[href*="/author/"]',
            )
            ?.text
            .trim() ??
        'Unknown';

    // GENRES

    final genreContainer =
        novelHeader.querySelectorAll(
      '.item',
    );

    List<String> genres = [];

    for (final item in genreContainer) {
      final icon = item.querySelector(
        '.glyphicon-th-list',
      );

      if (icon != null) {
        genres = item
            .querySelectorAll('.right a')
            .map(
              (e) =>
                  e.text.trim(),
            )
            .where(
              (e) => e.isNotEmpty,
            )
            .toList();

        break;
      }
    }

    // SOURCE

    String? source;

    for (final item in genreContainer) {
      final icon = item.querySelector(
        '.glyphicon-copy',
      );

      if (icon != null) {
        source = item
            .querySelector('.right a')
            ?.text
            .trim();

        break;
      }
    }

    // STATUS

    String? status;

    for (final item in genreContainer) {
      final icon = item.querySelector(
        '.glyphicon-time',
      );

      if (icon != null) {
        status = item
            .querySelector('.right')
            ?.text
            .trim();

        break;
      }
    }

    // RATING

    double? rating;

    final ratingText =
        novelHeader
            .querySelector(
              '.score .vote',
            )
            ?.text
            .trim();

    if (ratingText != null) {
      final match = RegExp(
        r'([\d.]+)',
      ).firstMatch(
        ratingText,
      );

      if (match != null) {
        rating = double.tryParse(
          match.group(1)!,
        );
      }
    }

    // DESCRIPTION

    final descriptionNodes =
        novelHeader.querySelectorAll(
      '.m-desc .inner p',
    );

    final description =
        descriptionNodes
            .map(
              (e) =>
                  e.text.trim(),
            )
            .where(
              (e) => e.isNotEmpty,
            )
            .toList();

    // CHAPTER COUNT

    String? chaptersCount;

    final chapterButton =
        novelHeader.querySelector(
      'a[title*="Chapter list"]',
    );

    if (chapterButton != null) {
      chaptersCount = chapterButton.text
          .trim();
    }
    final novelDetail = NovelDetailModal(
      keyId: keyId,
      title: title,
      author: author,
      imageUrl: imageUrl.isEmpty
          ? 'https://placeholder.com/no-image.png'
          : imageUrl,
      rating: rating,
      status: status,
      chaptersCount: chaptersCount,
      genres: genres,
      description: description,
      source: source,
      rank: null,
      views: null,
      novelUrl: novelUrl,
    );
    NovelsHiveHelper.saveNovelDetail(novelDetail as NovelDetailModal);
    return novelDetail;
  } catch (e) {
    print(
      'fetchFreeWebNovelDetail\$ error: $e',
    );

    return null;
  }
}