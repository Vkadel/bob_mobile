// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items_master.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemsMaster _$ItemsMasterFromJson(Map<String, dynamic> json) {
  return ItemsMaster(
    json['name'] as String,
    json['addition'] as int,
    json['subtraction'] as int,
    json['multiplier'] as int,
    json['cost'] as int,
    json['duration_days'] as int,
    json['id'] as int,
  )..status = json['status'] as int;
}

Map<String, dynamic> _$ItemsMasterToJson(ItemsMaster instance) =>
    <String, dynamic>{
      'name': instance.name,
      'addition': instance.addition,
      'multiplier': instance.multiplier,
      'subtraction': instance.subtraction,
      'cost': instance.cost,
      'duration_days': instance.duration_days,
      'status': instance.status,
      'id': instance.id,
    };
