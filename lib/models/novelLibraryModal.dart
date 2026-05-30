import 'package:hive/hive.dart';

// Generated adapter file is not available. Remove or regenerate as needed.
part 'novelLibraryModal.g.dart';

@HiveType(typeId: 1)
class NovelLibraryModal extends HiveObject {
  @HiveField(0)
  String keyId;
  @HiveField(1)
  String libraryName;
  @HiveField(2)
  String libraryImage;
  @HiveField(3)
  bool inUse;
  @HiveField(4)
  String webUrl;
  NovelLibraryModal({
    required this.keyId,
    required this.libraryName,
    required this.libraryImage,
    required this.inUse,
    required this.webUrl,
  });
  
}