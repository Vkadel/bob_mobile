// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) {
  return Team()
    ..leader_id = json['leader_id'] as String
    ..team_name = json['team_name'] as String
    ..leaderName = json['leaderName'] as String
    ..memberOneName = json['memberOneName'] as String
    ..memberTwoName = json['memberTwoName'] as String
    ..memberThreeName = json['memberThreeName'] as String
    ..points = json['points'] as int
    ..school_id = json['school_id'] as String
    ..invitationMemberOnePending = json['invitationMemberOnePending'] as bool
    ..invitationMemberTwoPending = json['invitationMemberTwoPending'] as bool
    ..invitationMemberThreePending =
        json['invitationMemberThreePending'] as bool
    ..invitationMemberOneAccepted = json['invitationMemberOneAccepted'] as bool
    ..invitationMemberTwoAccepted = json['invitationMemberTwoAccepted'] as bool
    ..invitationMemberThreeAccepted =
        json['invitationMemberThreeAccepted'] as bool
    ..teamIsActive = json['teamIsActive'] as bool;
}

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'leader_id': instance.leader_id,
      'team_name': instance.team_name,
      'leaderName': instance.leaderName,
      'memberOneName': instance.memberOneName,
      'memberTwoName': instance.memberTwoName,
      'memberThreeName': instance.memberThreeName,
      'points': instance.points,
      'school_id': instance.school_id,
      'invitationMemberOnePending': instance.invitationMemberOnePending,
      'invitationMemberTwoPending': instance.invitationMemberTwoPending,
      'invitationMemberThreePending': instance.invitationMemberThreePending,
      'invitationMemberOneAccepted': instance.invitationMemberOneAccepted,
      'invitationMemberTwoAccepted': instance.invitationMemberTwoAccepted,
      'invitationMemberThreeAccepted': instance.invitationMemberThreeAccepted,
      'teamIsActive': instance.teamIsActive,
    };
