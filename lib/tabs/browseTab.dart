import 'package:citayomi/data/novelLibraryData.dart';
// import 'package:citayomi/types/NovelLibraryType.dart';
import 'package:flutter/material.dart';
// import 'package:citayomi/data/novelLibraryData.dart';


class BrowseTab extends StatefulWidget {
  const BrowseTab({super.key});
  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
      appBar: AppBar(
          title: const Text('Browse'),
          // 2. Place the TabBar cleanly in the bottom slot of the AppBar
          bottom: const TabBar(
            // labelColor: Colors.white,
            // indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: 'Manga'),
              Tab(text: 'Novels'),
            ],
          ),
        ),
      body:const TabBarView(
          children: [
            Center(child: Text('Manga Sources Content')),
            NovelsLibraryWidget(),
          ],
        
      ),
    )
    );
  }

}



class NovelsLibraryWidget extends StatelessWidget {
  const NovelsLibraryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with your real Hive/Provider/Static list
    final novelLibrary = novelLibraryData; 

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,         // 3 items per row
        mainAxisSpacing: 12,       // Balanced spacing
        crossAxisSpacing: 12,
        childAspectRatio: 0.65,    // Crucial: Gives enough vertical room for text + image + text
      ),
      itemCount: novelLibrary.length,
      itemBuilder: (context, index) {
        final item = novelLibrary[index];

        return Card(
          clipBehavior: Clip.antiAlias, // Ensures InkWell splash doesn't bleed past Card corners
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => NovelDetailsScreen(item.keyId)));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Library Name at the top
                  Text(
                    item.libraryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  
                  // 2. Image below the Name with perfectly rounded corners
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item.libraryImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        // Elegant fallback handling if asset loading fails
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  
                  // 3. Subtitle / Status at the bottom
                  Text(
                    item.inUse ? 'Active' : 'Disabled',
                    style: TextStyle(
                      fontSize: 11, 
                      color: item.inUse ? Colors.greenAccent : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}