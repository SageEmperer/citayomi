import 'package:citayomi/models/NovelsModal/novelLibraryModal.dart';
import 'package:citayomi/services/novelServices/novels_library_fetch.dart';

import 'package:http/http.dart'
    as http;

import 'package:html/parser.dart'
    as parser;

import 'package:html/dom.dart'
    as dom;

Future<List<Map<String, dynamic>>>
    fetchFreeWebNovels$(
  String keyId,
  int page,
  {String filter = ""}
) async {

  try {

    final NovelLibraryModal? data =
        fetchNovelLibraryItem(
      keyId,
    );

    final baseUrl = data?.webUrl;

    if (baseUrl == null ||
        baseUrl.isEmpty) {
      return [];
    }
    final finalFilter = filter.isNotEmpty ? filter : "most-popular";
    var url = '';
    print("filtereeeeeeeeeeee");
    print(finalFilter);
    if (finalFilter == "most-popular") {
    url =
        '$baseUrl/sort/$finalFilter/';
    }else{
    url =
        '$baseUrl/sort/$finalFilter/$page';
    }
    print("final url");
    print(url);


    final response = await http.get(
      Uri.parse(url),

      headers: {
        'User-Agent':
            'Mozilla/5.0',
      },
    );

    if (response.statusCode != 200) {
      print("invalid respoinse");
      return [];
    }

    final dom.Document document =
        parser.parse(
      response.body,
    );

    final dom.Element? mainContainer =
        document.querySelector(
      'div.ul-list1.ul-list1-2.ss-custom',
    );

    if (mainContainer == null) {
      return [];
    }

    final List<dom.Element>
        novelItems =
        mainContainer
            .querySelectorAll(
      'div.li-row',
    );

    final novelList =
        novelItems.map((item) {

      final anchor =
          item.querySelector('a');

      final image =
          item.querySelector('img');

      final title =
          item
              .querySelector(
                'h3.tit',
              )
              ?.text
              .trim() ??
          '';

      final novelUrl =
          anchor?.attributes['href'] ??
          '';

      final novelUrlSplit = novelUrl.split('/'); 
      final novelUrlLast = novelUrlSplit.last;

      final imageUrl =
          image?.attributes['data-src'] ??
          image?.attributes['src'] ??
          '';

      final chapters =
          item
              .querySelector(
                '.s1',
              )
              ?.text
              .replaceAll(
                RegExp(r'\s+'),
                ' ',
              )
              .trim() ??
          '';

      final rating =
          item
              .querySelector(
                '._br',
              )
              ?.text
              .trim() ??
          '';

      final rank =
          item
              .querySelector(
                '._bl',
              )
              ?.text
              .trim() ??
          '';

      return {
        "title": title,

        "novelUrl":
            '$novelUrlLast',

        "imageUrl":
            '$baseUrl$imageUrl',

        "chapters":
            chapters,

        "rating":
            rating,

        "rank":
            rank,
      };

    }).toList();

    return novelList;

  } catch (e) {

    print(
      'fetchFireNovels\$ Error: $e',
    );

    return [];
  }
}