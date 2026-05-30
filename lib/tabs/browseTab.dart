import 'package:citayomi/components/cards/sourceCard.dart';
import 'package:citayomi/pages/novelPages/novel_library_page.dart';
import 'package:citayomi/services/novelServices/novels_library_fetch.dart';
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
    final novelLibrary = fetchNovelLibraryData(); 

    return ListView.separated(
  padding: const EdgeInsets.all(12),
  itemCount: novelLibrary.length,
  separatorBuilder: (_, __) => const SizedBox(height: 12),
  itemBuilder: (context, index) {
    final item = novelLibrary[index];

    return SourceCard(
          imageSource: item.libraryImage,
          title: item.libraryName,
          subtitle: "English",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NovelLibraryPage(
                  novelKey: item.keyId,
              )),
            );
          }
        );
  },
);
  }
}