class NovelLibraryType {
  final String keyId;
  String libraryName;
  String libraryImage;
  String webUrl;
  bool inUse;

  NovelLibraryType({
    required this.keyId,
    required this.libraryName,
    required this.libraryImage,
    required this.webUrl,
    this.inUse = false,
  });
}