import 'package:citayomi/components/navBars/mangaNavBar.dart';
import 'package:flutter/material.dart';

class MangaTab extends StatelessWidget {
  const MangaTab({super.key});

  // Changed to strongly-typed Map list for type-safety and performance
  static const List<Map<String, String>> mangaList = [
    {
      'title': 'One Piece',
      'image': 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=500&q=80',
    },
    {
      'title': 'Naruto',
      'image': 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=500&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MangaNavBar(),
      // Removed the unnecessary Center widget; GridView automatically manages its constraints
      body: GridView.builder(
        padding: const EdgeInsets.all(8), // Padding around the entire grid edge
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,   // Horizontal spacing between grid tiles
          mainAxisSpacing: 8,    // Vertical spacing between grid tiles
          childAspectRatio: 0.7, // Essential: Enforces a taller layout appropriate for book/manga covers
        ),
        itemCount: mangaList.length,
        itemBuilder: (context, index) {
          final manga = mangaList[index];

          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias, // Ensures child widgets conform to border radius
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Core Image Layer with error handling
                Image.network(
                  manga['image']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.broken_image, color: Colors.white38),
                    );
                  },
                ),
                
                // 2. Bottom Gradient Shadow Overlay for Text Readability (UX Requirement)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.85),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      manga['title']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis, // Adds "..." if text is too long
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}