// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Items _$ItemsFromJson(Map<String, dynamic> json) {
  return Items(
    json['item'] as int,
    json['status'] as int,
    json['id'] as String,
    json['endDate'] as int,
    json['inuse'] as bool,
  );
}

Map<String, dynamic> _$ItemsToJson(Items instance) => <String, dynamic>{
      'id': instance.id,
      'item': instance.item,
      'status': instance.status,
      'inuse': instance.inuse,
      'endDate': instance.endDate,
    };
