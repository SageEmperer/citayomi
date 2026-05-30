// using hive fetch it

import 'package:citayomi/models/novelLibraryModal.dart';
import 'package:hive_flutter/hive_flutter.dart';


List<NovelLibraryModal> fetchNovelLibraryData() {
  final box = Hive.box<NovelLibraryModal>('novelLibrary');
  return box.values.toList();
}

NovelLibraryModal? fetchNovelLibraryItem(String keyId) {
  try{
    print("keyId---------------: $keyId");
    final box = Hive.box<NovelLibraryModal>('novelLibrary');
    print("box: ${box.values.toList()}");
    for (final item in box.values.toList()) {
      if (item.keyId == keyId) return item;
    }
    return null;

  }catch(e){
    print("error: $e");
    return null;
  }
}