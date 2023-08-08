// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final String uid;
  final double rating;
  final String comment;
  final String username;
  final Timestamp timestamp;
  final String profile;
  Rating({
    required this.uid,
    required this.rating,
    required this.comment,
    required this.username,
    required this.timestamp,
    required this.profile,
  });

  Rating copyWith({
    String? uid,
    double? rating,
    String? comment,
    String? username,
    Timestamp? timestamp,
    String? profile,
  }) {
    return Rating(
      uid: uid ?? this.uid,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      username: username ?? this.username,
      timestamp: timestamp ?? this.timestamp,
      profile: profile ?? this.profile,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'rating': rating,
      'comment': comment,
      'username': username,
      'timestamp': timestamp,
      'profile': profile,
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      uid: map['uid'] as String,
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'] as String,
      username: map['username'] as String,
      timestamp: map['timestamp'] as Timestamp,
      profile: map['profile'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rating.fromJson(String source) =>
      Rating.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Rating(uid: $uid, rating: $rating, comment: $comment, username: $username, timestamp: $timestamp, profile: $profile)';
  }
}
