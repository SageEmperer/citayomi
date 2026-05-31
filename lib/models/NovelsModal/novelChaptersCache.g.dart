// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novelChaptersCache.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NovelChaptersCacheAdapter extends TypeAdapter<NovelChaptersCache> {
  @override
  final int typeId = 4;

  @override
  NovelChaptersCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NovelChaptersCache(
      keyId: fields[0] as String,
      novelUrl: fields[1] as String,
      chapters: (fields[2] as List).cast<NovelChaptersModal>(),
    );
  }

  @override
  void write(BinaryWriter writer, NovelChaptersCache obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.keyId)
      ..writeByte(1)
      ..write(obj.novelUrl)
      ..writeByte(2)
      ..write(obj.chapters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NovelChaptersCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
