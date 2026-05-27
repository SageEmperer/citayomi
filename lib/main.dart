import 'package:citayomi/tabs/browseTab.dart';
import 'package:citayomi/tabs/mangaTab.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack preserves page state and scroll positions when switching tabs
      body: IndexedStack(
        index: _selectedIndex,
        children: const <Widget>[
          MangaTab(),
          Center(child: Text('Light Novels', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
          Center(child: Text('Latest Updates', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
          BrowseTab(),
          Center(child: Text('Settings & More', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
        ],
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // CRITICAL: Forces labels and styling to remain constant with 4+ items
        type: BottomNavigationBarType.fixed, 
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.white, // Clear visual highlight for active tab
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories), // Semantic book/manga icon
            label: 'Manga',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book), // Solid single book icon for novels
            label: 'Novel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active), // Alarm/bell for release updates
            label: 'Updates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore), // Compass for discovery/browsing
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz), // Standard three-dot menu icon
            label: 'More',
          ),
        ],
      ),
    );
  }
}