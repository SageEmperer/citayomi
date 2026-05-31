

import 'package:citayomi/types/NovelLibraryType.dart';

final List<NovelLibraryType> novelLibraryData = [

  NovelLibraryType(
    keyId: "freewebnovel",
    libraryName: "Free Web Novel",
    libraryImage: "assets/novelsLibraryImages/freewebnovel.png",
    webUrl:"https://freewebnovel.com",
    inUse: true,
    filters: [
      {
        "filterName": "Popular",
        "filterValue": "most-popular",
      },
      {
        "filterName": "Latest",
        "filterValue": "latest-novel",
      },
      {
        "filterName": "Completed",
        "filterValue": "completed-novel",
      }
    ],

  ),
  NovelLibraryType(
    keyId: "firenovel",
    libraryName: "Fire Novel",
    libraryImage: "assets/novelsLibraryImages/novelfire.png",
    webUrl:"https://novelfire.net",
    inUse: true,
  ),

];