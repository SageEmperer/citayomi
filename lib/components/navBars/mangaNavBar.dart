import 'package:flutter/material.dart';

class MangaNavBar extends StatefulWidget implements PreferredSizeWidget {
  const MangaNavBar({super.key});

  @override
  State<MangaNavBar> createState() => _MangaNavBarState();

  // Crucial: Defines the standard height for the AppBar framework implementation
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MangaNavBarState extends State<MangaNavBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: _isSearching
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _stopSearch,
            )
          : null,
      title: _isSearching
          ? TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                hintText: 'Search manga...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white60),
              ),
              onChanged: (query) {
                // Handle search filtering
              },
            )
          : const Text('Manga'),
      actions: _isSearching
          ? [
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _searchController.clear(),
              ),
            ]
          : [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _startSearch,
              ),
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () {},
              ),
            ],
    );
  }
}