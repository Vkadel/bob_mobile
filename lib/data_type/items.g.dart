// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Items _$ItemsFromJson(Map<String, dynamic> json) {
  return Items(json['item'] as String, json['status'] as int);
}

Map<String, dynamic> _$ItemsToJson(Items instance) =>
    <String, dynamic>{'item': instance.item, 'status': instance.status};
