


import 'package:citayomi/models/novelLibraryModal.dart';
import 'package:citayomi/services/novelServices/novels_library_fetch.dart';
import 'package:citayomi/types/NovelDetailType.dart';

import 'package:http/http.dart'
    as http;

import 'package:html/parser.dart'
    as parser;

import 'package:html/dom.dart'
    as dom;



Future<NovelDetailType?> fetchFireNovelDetail$(String keyId, String novelUrl) async {
  try {
    final NovelLibraryModal? novelData = fetchNovelLibraryItem(keyId);
    if (novelData == null) return null;

    final baseUrl = novelData.webUrl;
    // CRITICAL FIX: Base info sits at /book/novel-name, not /book/novel-name/chapters
    final url = '$baseUrl/book/$novelUrl';
    
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      },
    );

    if (response.statusCode != 200) {
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
    print(title);
    print("title");
    print(author);
    print("author");
    print(imageUrl);
    print("imageUrl");
    print(rank);
    print("rank");
    print(rating);
    print("rating");
    print(status);
    print("status");
    print(views);
    print("views");
    print(chaptersCount);
    print("chaptersCount");
    print(genres);
    print("genres");    

    return NovelDetailType(
      title: title,
      author: author,
      imageUrl: imageUrl.isEmpty ? "https://placeholder.com/no-image.png" : imageUrl,
      rank: rank,
      rating: rating,
      status: status,
      views: views,
      chaptersCount: chaptersCount,
      genres: genres,
    );

  } catch (e) {
    // Production log tracking approach
    print("error $e");
    return null;
  }
}