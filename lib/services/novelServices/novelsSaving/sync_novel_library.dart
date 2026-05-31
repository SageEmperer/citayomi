import 'package:citayomi/models/NovelsModal/novelLibraryModal.dart';
import 'package:citayomi/types/NovelLibraryType.dart';
import 'package:hive_flutter/adapters.dart';

/// Synchronizes hardcoded assets with local Hive persistence state safely
Future<void> syncNovelLibraryData(Box<NovelLibraryModal> box, List<NovelLibraryType> incomingData) async {
  if (box.isEmpty) {
    final Map<String, NovelLibraryModal> initialMap = {
      for (var item in incomingData) 
        item.keyId: NovelLibraryModal(
          keyId: item.keyId,
          libraryName: item.libraryName,
          libraryImage: item.libraryImage,
          inUse: item.inUse,
          webUrl: item.webUrl, // Use correct field reference matching your model
        )
    };
    await box.putAll(initialMap);
    return;
  }

  final Map<String, NovelLibraryModal> updatesToApply = {};

  for (final incomingItem in incomingData) {
    final NovelLibraryModal? existingItem = box.get(incomingItem.keyId);

    if (existingItem == null) {
      // Scenario A: Completely new item discovered -> Append to database
      updatesToApply[incomingItem.keyId] = NovelLibraryModal(
        keyId: incomingItem.keyId,
        libraryName: incomingItem.libraryName,
        libraryImage: incomingItem.libraryImage,
        inUse: incomingItem.inUse,
        webUrl: incomingItem.webUrl,
        filters: incomingItem.filters,
      );
    } else {
      // Scenario B: Item already exists -> Update structural metadata, 
      // but retain local user runtime state overrides like 'inUse'.
      final updatedItem = NovelLibraryModal(
        keyId: incomingItem.keyId,
        libraryName: incomingItem.libraryName,
        libraryImage: incomingItem.libraryImage,
        inUse: existingItem.inUse, // Preserves user toggle choice
        webUrl: incomingItem.webUrl, // FIXED: Accepts the incoming updated URL string configuration
        filters: incomingItem.filters,
      );
      
      updatesToApply[incomingItem.keyId] = updatedItem;
    }
  }

  if (updatesToApply.isNotEmpty) {
    await box.putAll(updatesToApply);
  }
}