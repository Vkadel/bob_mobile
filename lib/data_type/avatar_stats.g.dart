// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvatarStats _$AvatarStatsFromJson(Map<String, dynamic> json) {
  return AvatarStats(
      json['additions'] as Map<String, dynamic>,
      json['substractions'] as Map<String, dynamic>,
      json['multipliers'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AvatarStatsToJson(AvatarStats instance) =>
    <String, dynamic>{
      'additions': instance.additions,
      'substractions': instance.substractions,
      'multipliers': instance.multipliers
    };
