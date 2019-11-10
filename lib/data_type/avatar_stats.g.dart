// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvatarStats _$AvatarStatsFromJson(Map<String, dynamic> json) {
  return AvatarStats(
    json['additions'] as Map<dynamic, dynamic>,
    json['substractions'] as Map<dynamic, dynamic>,
    json['multipliers'] as Map<dynamic, dynamic>,
  );
}

Map<String, dynamic> _$AvatarStatsToJson(AvatarStats instance) =>
    <String, dynamic>{
      'additions': instance.additions,
      'substractions': instance.substractions,
      'multipliers': instance.multipliers,
    };
