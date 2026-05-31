// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novelChaptersModal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NovelChaptersModalAdapter extends TypeAdapter<NovelChaptersModal> {
  @override
  final int typeId = 3;

  @override
  NovelChaptersModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NovelChaptersModal(
      keyId: fields[0] as String,
      novelUrl: fields[1] as String,
      chapterUrl: fields[2] as String,
      chapterTitle: fields[3] as String,
      chapterNumber: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NovelChaptersModal obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.keyId)
      ..writeByte(1)
      ..write(obj.novelUrl)
      ..writeByte(2)
      ..write(obj.chapterUrl)
      ..writeByte(3)
      ..write(obj.chapterTitle)
      ..writeByte(4)
      ..write(obj.chapterNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NovelChaptersModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
