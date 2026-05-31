import 'package:citayomi/components/ui/genreBadge.dart';
import 'package:citayomi/models/NovelsModal/novelChaptersModal.dart';
import 'package:citayomi/models/NovelsModal/novelDetailModal.dart';
import 'package:citayomi/services/novelServices/novels_in_library_fetch.dart'; // Assumed container of NovelScraper
import 'package:citayomi/types/NovelChaptersType.dart';
import 'package:citayomi/types/NovelDetailType.dart';
import 'package:flutter/material.dart';

class NovelDetailPage extends StatefulWidget {
  final String? keyId;
  final String? novelUrl;

  const NovelDetailPage({
    super.key,
    this.keyId,
    this.novelUrl,
  });

  @override
  State<NovelDetailPage> createState() => _NovelDetailPageState();
}

class _NovelDetailPageState extends State<NovelDetailPage> {
  NovelDetailModal? _novelDetailData;
  bool _isLoading = true;
  List<NovelChaptersModal> _novelChapters = [];
  bool _isChaptersLoading = true;
  bool _novelChaptersFailed = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.keyId != null && widget.novelUrl != null) {
        _fetchNovelDetail(widget.keyId!, widget.novelUrl!);
        _fetchNovelChapters(widget.keyId!, widget.novelUrl!);
      } else {
        setState(() {
          _isLoading = false;
          _isChaptersLoading = false;
        });
      }
    });
  }

  Future<void> _fetchNovelDetail(String keyId, String novelUrl , {bool foreceRefresh = false}) async {
    try {
      final data = await NovelScraper.scrapeNovelDetail(keyId, novelUrl, foreceRefresh: foreceRefresh);
      if (!mounted) return;
      setState(() {
        _novelDetailData = data;
      });
    } catch (e) {
      debugPrint('Error fetching novel details: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchNovelChapters(String keyId, String novelUrl , {bool foreceRefresh = false}) async {
    try {
      final data = await NovelScraper.scrapeNovelChapters(keyId, novelUrl, foreceRefresh: foreceRefresh);
      if (!mounted) return;
      setState(() {
        _novelChapters = data;
        _novelChaptersFailed = false;
      });
    } catch (e) {
      debugPrint("Error fetching novel chapters: $e");
      if (mounted) {
        setState(() {
          _novelChaptersFailed = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isChaptersLoading = false;
        });
      }
    }
  }



  Future<void> _reloadData() async {
    if (widget.keyId == null ||
        widget.novelUrl == null) {
      return;
    }

    setState(() {
      _isLoading = true;
      _isChaptersLoading = true;
      _novelChaptersFailed = false;
    });
    await Future.wait([
      _fetchNovelDetail(
        widget.keyId!,
        widget.novelUrl!,
        foreceRefresh: true,
      ),
      _fetchNovelChapters(
        widget.keyId!,
        widget.novelUrl!,
        foreceRefresh: true,
      ),
    ]);
  }



  Widget _infoChip(ThemeData theme, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, NovelDetailModal data) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Hero(
                  tag: data.imageUrl,
                  child: Image.network(
                    data.imageUrl,
                    width: 120,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 120,
                      height: 180,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.broken_image_outlined, size: 40),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(data.author, style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 4),
                    Text(
                      data.source ?? 'Unknown Source',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (data.rating != null)
                          _infoChip(theme, Icons.star, data.rating!.toString()),
                        _infoChip(
                          theme,
                          Icons.menu_book,
                          _isChaptersLoading ? '...' : _novelChapters.length.toString(),
                        ),
                        if (data.status != null)
                          _infoChip(theme, Icons.circle, data.status!),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
                label: const Text("Library"),
              ),
              IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(Icons.share),
              ),
              IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(Icons.open_in_new),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (data.genres.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: data.genres.map((genre) => GenreBadge(text: genre)).toList(),
            ),
          const SizedBox(height: 20),
          Text(
            "Synopsis",
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...data.description.map(
            (desc) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(desc, style: theme.textTheme.bodyMedium),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Correctly returns a Sliver based on asynchronous state
  Widget _buildNovelChapters(ThemeData theme) {
    if (_isChaptersLoading) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_novelChaptersFailed) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('Failed to fetch novel chapters')),
        ),
      );
    }

    if (_novelChapters.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No chapters found')),
        ),
      );
    }

    return SliverList.builder(
      itemCount: _novelChapters.length,
      itemBuilder: (context, index) {
        final chapter = _novelChapters[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              radius: 18,
              child: Text(
                chapter.chapterNumber.toString(),
                style: const TextStyle(fontSize: 11),
              ),
            ),
            title: Text(
              chapter.chapterTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text('Chapter ${chapter.chapterNumber}'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              // Contextually safe handling execution to navigate to specific dynamic reading viewport
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final data = _novelDetailData;
    if (data == null) {
      return const Scaffold(
        body: Center(child: Text('No Novel Found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
      ),
      body: RefreshIndicator(
        onRefresh: _reloadData,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(theme, data),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _isChaptersLoading ? "Chapters" : "Chapters (${_novelChapters.length})",
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 12),
            ),
            _buildNovelChapters(theme),
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }
}