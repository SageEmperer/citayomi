import 'package:citayomi/components/cards/CustomitemCard.dart';
import 'package:citayomi/models/novelLibraryModal.dart';
import 'package:citayomi/pages/novelPages/novel_detail_page.dart';
import 'package:citayomi/services/novelServices/novels_in_library_fetch.dart';
import 'package:citayomi/services/novelServices/novels_library_fetch.dart';
import 'package:flutter/material.dart';

class NovelLibraryPage extends StatefulWidget {
  final String novelKey;

  const NovelLibraryPage({
    super.key,
    required this.novelKey,
  });

  @override
  State<NovelLibraryPage> createState() =>
      _NovelLibraryPageState();
}

class _NovelLibraryPageState
    extends State<NovelLibraryPage> {
  final ScrollController _scrollController =
      ScrollController();

  final List<Map<String, dynamic>> novels = [];

  bool isLoading = false;
  bool hasMore = true;
  bool isFirstLoading = true;
  bool isEmptyPage = false;

  int page = 1;

  NovelLibraryModal? novelLibrary;

  @override
  void initState() {
    super.initState();

    novelLibrary =
        fetchNovelLibraryItem(widget.novelKey);

    fetchNovels(isFirst: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController
                      .position.maxScrollExtent -
                  300 &&
          !isLoading &&
          hasMore) {
        fetchNovels();
      }
    });
  }

  Future<void> fetchNovels({
    bool isFirst = false,
  }) async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      final result =
          await NovelScraper.scrapeNovels(
        widget.novelKey,
        page,
      );

      setState(() {
        if (result.isEmpty) {
          hasMore = false;

          if (isFirst) {
            isEmptyPage = true;
          }
        } else {
          novels.addAll(result);
          page++;
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
        isFirstLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        title: Text(
          novelLibrary?.libraryName ??
              'Library',
        ),
      ),

      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // First loading
    if (isFirstLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Empty state
    if (isEmptyPage) {
      return const Center(
        child: Text(
          'No novels found',
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: _scrollController,

            padding:
                const EdgeInsets.all(12),

            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),

            itemCount: novels.length,

            itemBuilder: (
              context,
              index,
            ) {
              final novel = novels[index];

              return CustomItemCard(
                imgUrl:
                    novel['imageUrl'],
                title:
                    novel['title'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NovelDetailPage(
                        keyId: novel['keyId'],
                        novelUrl: novel['novelUrl'],
                    )),
                  );
                },
              );
            },
          ),
        ),

        // Bottom pagination loader
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(16),
            child:
                CircularProgressIndicator(),
          ),
      ],
    );
  }
}