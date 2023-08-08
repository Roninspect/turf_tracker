// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Favorite {
  final String fid;
  final String turfId;
  final String uid;
  Favorite({
    required this.fid,
    required this.turfId,
    required this.uid,
  });

  Favorite copyWith({
    String? fid,
    String? turfId,
    String? uid,
  }) {
    return Favorite(
      fid: fid ?? this.fid,
      turfId: turfId ?? this.turfId,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fid': fid,
      'turfId': turfId,
      'uid': uid,
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      fid: map['fid'] as String,
      turfId: map['turfId'] as String,
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Favorite.fromJson(String source) =>
      Favorite.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Favorite(fid: $fid, turfId: $turfId, uid: $uid)';

  @override
  bool operator ==(covariant Favorite other) {
    if (identical(this, other)) return true;

    return other.fid == fid && other.turfId == turfId && other.uid == uid;
  }

  @override
  int get hashCode => fid.hashCode ^ turfId.hashCode ^ uid.hashCode;
}
