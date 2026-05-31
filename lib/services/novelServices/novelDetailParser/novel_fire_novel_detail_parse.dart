


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



Future<NovelDetailModal?> fetchFireNovelDetail$(String keyId, String novelUrl) async {
  try {
    final NovelLibraryModal? novelData = fetchNovelLibraryItem(keyId);
    if (novelData == null) return null;

    final baseUrl = novelData.webUrl;
    final url = '$baseUrl/book/$novelUrl';
    print("final url");
    print(url);
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      },
    );

    if (response.statusCode != 200) {
      print("error getting the status code");
      return null;
    }

    final dom.Document document = parser.parse(response.body);
    final novelHeader = document.querySelector('header.novel-header');
    if (novelHeader == null) return null;

    final infoContainer = novelHeader.querySelector('div.novel-info');
    if (infoContainer == null) return null;

    // 1. Core Fields (Guaranteed Targets)
    final String title = infoContainer.querySelector('h1.novel-title')?.text.trim() ?? "Unknown Title";
    
    // Explicit targeting of the semantic anchor tag inside the author div
    final String author = infoContainer.querySelector('div.author span[itemprop="author"]')?.text.trim() ?? 
                          infoContainer.querySelector('div.author a')?.text.trim() ?? "Unknown Author";

    // Extract raw string target from the primary structural element
    final String imageUrl = novelHeader.querySelector('div.fixed-img img')?.attributes['src'] ?? '';

    // 2. Optional Metadata & Performance Stats
    final String? rank = infoContainer.querySelector('div.rank strong')?.text.trim();
    
    // Convert text metric safely to double type
    final String? rawRating = infoContainer.querySelector('strong.nub')?.text.trim();
    final double? rating = rawRating != null ? double.tryParse(rawRating) : null;

    // 3. Stats Iteration Map
    String? status;
    String? views;
    String? chaptersCount;

    final statItems = infoContainer.querySelectorAll('div.header-stats span');
    for (var item in statItems) {
      final smallText = item.querySelector('small')?.text.trim().toLowerCase() ?? '';
      final valueText = item.querySelector('strong')?.text.trim() ?? '';
      
      if (smallText.contains('status')) {
        status = valueText;
      } else if (smallText.contains('views')) {
        views = valueText;
      } else if (smallText.contains('chapters')) {
        chaptersCount = valueText;
      }
    }

    // 4. Array Extraction (Genres)
    final List<String> genres = infoContainer
        .querySelectorAll('div.categories ul li a')
        .map((element) => element.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();
    final description = document
        .querySelector('.summary .content')
        ?.text
        .trim() ??
    document
        .querySelector('div.content.expand-wrapper.no-expand')
        ?.text
        .trim() ??
    '';

    // fetching the chapters list ====================================================================
    final chapterUrl = '$baseUrl/book/$novelUrl/chapters';

    final chapterResponse = await http.get(
      Uri.parse(chapterUrl),
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      },
    );
    if (chapterResponse.statusCode != 200) {
      print("error getting the status code");
      return null;
    }
    final chapterDom = parser.parse(chapterResponse.body);
    final patinationItems = chapterDom.querySelectorAll('ul.pagination li');
    var highestPage = 1;
    for (var item in patinationItems) {
      try{
        final page = int.parse(item.text.trim());
        if (page > highestPage) {
          highestPage = page;
        }
      }catch(e){
        print("error: $e");
      }
    }

    // range based on highest page
    // for (var i = 1; i <= highestPage; i++) {
    //   final chapterPageUrl = '$baseUrl/book/$novelUrl/chapters';

    // }
    final novelDetail = NovelDetailModal(
      keyId: keyId,
      title: title,
      author: author,
      imageUrl: imageUrl.isEmpty ? "https://placeholder.com/no-image.png" : imageUrl,
      rank: rank,
      rating: rating,
      status: status,
      views: views,
      chaptersCount: chaptersCount,
      genres: genres,
      novelUrl: novelUrl,
      description: description.split('\n'),
    );
    NovelsHiveHelper.saveNovelDetail(novelDetail as NovelDetailModal);
    return novelDetail;

  } catch (e) {
    // Production log tracking approach
    print("error $e");
    return null;
  }
}