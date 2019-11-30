// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_points.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamPoints _$TeamPointsFromJson(Map<String, dynamic> json) {
  return TeamPoints(
    json['team_points'] as int,
    json['id'] as Map<dynamic, dynamic>,
    json['team_name'] as String,
  );
}

Map<String, dynamic> _$TeamPointsToJson(TeamPoints instance) =>
    <String, dynamic>{
      'team_points': instance.team_points,
      'id': instance.id,
      'team_name': instance.team_name,
    };
