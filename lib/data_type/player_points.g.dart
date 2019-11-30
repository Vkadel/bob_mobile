// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_points.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerPoints _$PlayerPointsFromJson(Map<String, dynamic> json) {
  return PlayerPoints(
    json['player_points'] as int,
    json['id'] as String,
    json['player_name'] as String,
  )..playerTeamId = json['playerTeamId'] as bool;
}

Map<String, dynamic> _$PlayerPointsToJson(PlayerPoints instance) =>
    <String, dynamic>{
      'player_points': instance.player_points,
      'id': instance.id,
      'player_name': instance.player_name,
      'playerTeamId': instance.playerTeamId,
    };
