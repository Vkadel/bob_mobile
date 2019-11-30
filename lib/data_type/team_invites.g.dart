// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_invites.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamInvites _$TeamInvitesFromJson(Map<String, dynamic> json) {
  return TeamInvites(
    team_id: json['team_id'] as String,
    invited_name: json['invited_name'] as String,
    team_name: json['team_name'] as String,
    from: json['from'] as String,
    accepted: json['accepted'] as bool,
    pending: json['pending'] as bool,
    date_sent: json['date_sent'] as int,
  );
}

Map<String, dynamic> _$TeamInvitesToJson(TeamInvites instance) =>
    <String, dynamic>{
      'team_name': instance.team_name,
      'invited_name': instance.invited_name,
      'team_id': instance.team_id,
      'from': instance.from,
      'accepted': instance.accepted,
      'pending': instance.pending,
      'date_sent': instance.date_sent,
    };
