

  class NovelLibraryType {
    final String keyId;
    String libraryName;
    String libraryImage;
    String webUrl;
    bool inUse;
    List<Map<String, String>> filters;
    NovelLibraryType({
      required this.keyId,
      required this.libraryName,
      required this.libraryImage,
      required this.webUrl,
      this.inUse = false,
      this.filters = const [],
    });
  }