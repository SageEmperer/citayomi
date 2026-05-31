// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novelLibraryModal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NovelLibraryModalAdapter extends TypeAdapter<NovelLibraryModal> {
  @override
  final int typeId = 1;

  @override
  NovelLibraryModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NovelLibraryModal(
      keyId: fields[0] as String,
      libraryName: fields[1] as String,
      libraryImage: fields[2] as String,
      inUse: fields[3] as bool,
      webUrl: fields[4] as String,
      filters: (fields[5] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, NovelLibraryModal obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.keyId)
      ..writeByte(1)
      ..write(obj.libraryName)
      ..writeByte(2)
      ..write(obj.libraryImage)
      ..writeByte(3)
      ..write(obj.inUse)
      ..writeByte(4)
      ..write(obj.webUrl)
      ..writeByte(5)
      ..write(obj.filters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NovelLibraryModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
