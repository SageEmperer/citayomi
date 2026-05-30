import 'package:citayomi/services/novelServices/novels_in_library_fetch.dart';
import 'package:citayomi/types/NovelDetailType.dart';
import 'package:flutter/material.dart';

class NovelDetailPage extends StatefulWidget {
  // Pass required parameters down from the router/navigator
  String? keyId;
  String? novelUrl;

  NovelDetailPage({
    super.key,
    this.keyId,
    this.novelUrl,
  });

  @override
  State<NovelDetailPage> createState() => _NovelDetailPageState();
}

class _NovelDetailPageState extends State<NovelDetailPage> {
  NovelDetailType? _novelDetailData;
  bool _isLoading = true; // Default to true to prevent a flash of "No Novel Found"

  @override
  void initState() {
    super.initState();
    // Safely trigger data fetching after the first frame execution
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.keyId != null && widget.novelUrl != null) {
        _fetchNovelDetail(widget.keyId!, widget.novelUrl!);
      } else if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _fetchNovelDetail(String keyId, String novelUrl) async {
    try {
      final NovelDetailType? data = await NovelScraper.scrapeNovelDetail(keyId, novelUrl);
      if (!mounted) return;

      setState(() {
        _novelDetailData = data;
      });
    } catch (e) {
      debugPrint("Error fetching novel details: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_novelDetailData?.title ?? 'Novel Detail'),
        elevation: 0,
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Capture state immutably for local scope type-casting
    final data = _novelDetailData;
    if (data == null) {
      return const Center(
        child: Text('No Novel Found'),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Core Info Layout: Cover Image alongside detailed text metadata
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Cover: Enforces a clean 2:3 aspect ratio
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  data.imageUrl ?? "" , // Fallback to avoid empty strings passing to NetworkImage
                  height: 150,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    width: 100,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.broken_image, size: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              
              // Novel Metadata Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title ?? "Unknown Title",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      "Author: ${data.author ?? 'Unknown'}",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      "Source: ${data.source ?? 'Unknown'}",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    
                    // Status Badge
                    if (data.status != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          data.status!.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(),
          ),
          
          Text(
            "Synopsis",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            data.description ?? "No description available.",
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}