// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'icon.dart';

class Team {
  String tid;
  String name;
  String nameInLowerCase;
  String teamProfile;
  List<String> members;
  List<String> mods;
  List<IconModel> sportsPlays;
  Team({
    required this.tid,
    required this.name,
    required this.nameInLowerCase,
    required this.teamProfile,
    required this.members,
    required this.mods,
    required this.sportsPlays,
  });

  Team copyWith(
      {String? tid,
      String? name,
      String? nameInLowerCase,
      String? teamProfile,
      List<String>? members,
      List<IconModel>? sportsPlays,
      List<String>? mods}) {
    return Team(
        tid: tid ?? this.tid,
        name: name ?? this.name,
        nameInLowerCase: nameInLowerCase ?? this.nameInLowerCase,
        teamProfile: teamProfile ?? this.teamProfile,
        members: members ?? this.members,
        sportsPlays: sportsPlays ?? this.sportsPlays,
        mods: mods ?? this.mods);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tid': tid,
      'name': name,
      "nameInLowerCase": nameInLowerCase,
      'teamProfile': teamProfile,
      'members': members,
      'sportsPlays': sportsPlays.map((x) => x.toMap()).toList(),
      "mods": mods,
    };
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      tid: map['tid'] as String,
      name: map['name'] as String,
      nameInLowerCase: map['nameInLowerCase'] as String,
      teamProfile: map['teamProfile'] as String,
      members: List<String>.from(
          (map['members'] as List<dynamic>).map((e) => e.toString())),
      sportsPlays: List<IconModel>.from(
        (map['sportsPlays'] as List<dynamic>).map<IconModel>(
          (x) => IconModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      mods: List<String>.from(
          (map['mods'] as List<dynamic>).map((e) => e.toString())),
    );
  }

  String toJson() => json.encode(toMap());

  factory Team.fromJson(String source) =>
      Team.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Team(tid: $tid, name: $name, teamProfile: $teamProfile, members: $members)';
  }

  @override
  bool operator ==(covariant Team other) {
    if (identical(this, other)) return true;

    return other.tid == tid &&
        other.name == name &&
        other.teamProfile == teamProfile &&
        listEquals(other.members, members);
  }

  @override
  int get hashCode {
    return tid.hashCode ^
        name.hashCode ^
        teamProfile.hashCode ^
        members.hashCode;
  }
}
