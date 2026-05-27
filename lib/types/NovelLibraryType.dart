class NovelLibrary {
  final String keyId;
  String libraryName;
  String libraryImage;
  bool inUse;

  NovelLibrary({
    required this.keyId,
    required this.libraryName,
    required this.libraryImage,
    this.inUse = false,
  });
}