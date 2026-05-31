// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novelDetailModal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NovelDetailModalAdapter extends TypeAdapter<NovelDetailModal> {
  @override
  final int typeId = 2;

  @override
  NovelDetailModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NovelDetailModal(
      keyId: fields[0] as String,
      title: fields[1] as String,
      author: fields[2] as String,
      imageUrl: fields[3] as String,
      novelUrl: fields[12] as String,
      rank: fields[4] as String?,
      rating: fields[5] as double?,
      status: fields[6] as String?,
      views: fields[7] as String?,
      chaptersCount: fields[8] as String?,
      genres: (fields[9] as List).cast<String>(),
      description: (fields[10] as List).cast<String>(),
      source: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NovelDetailModal obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.keyId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.rank)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.views)
      ..writeByte(8)
      ..write(obj.chaptersCount)
      ..writeByte(9)
      ..write(obj.genres)
      ..writeByte(10)
      ..write(obj.description)
      ..writeByte(11)
      ..write(obj.source)
      ..writeByte(12)
      ..write(obj.novelUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NovelDetailModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
