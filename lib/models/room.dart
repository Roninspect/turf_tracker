// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String uid;
  final String turfId;
  final String turfName;
  final String turfAddress;
  final String dimension;
  final String bookedBy;
  final Timestamp startTime;
  final Timestamp endTime;
  final num totalPrice;
  Room({
    required this.uid,
    required this.turfId,
    required this.turfName,
    required this.turfAddress,
    required this.dimension,
    required this.bookedBy,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
  });

  Room copyWith({
    String? uid,
    String? turfId,
    String? turfName,
    String? turfAddress,
    String? dimension,
    String? bookedBy,
    Timestamp? startTime,
    Timestamp? endTime,
    num? totalPrice,
  }) {
    return Room(
      uid: uid ?? this.uid,
      turfId: turfId ?? this.turfId,
      turfName: turfName ?? this.turfName,
      turfAddress: turfAddress ?? this.turfAddress,
      dimension: dimension ?? this.dimension,
      bookedBy: bookedBy ?? this.bookedBy,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'turfId': turfId,
      'turfName': turfName,
      'turfAddress': turfAddress,
      'dimension': dimension,
      'bookedBy': bookedBy,
      'startTime': startTime,
      'endTime': endTime,
      'totalPrice': totalPrice,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      uid: map['uid'] as String,
      turfId: map['turfId'] as String,
      turfName: map['turfName'] as String,
      turfAddress: map['turfAddress'] as String,
      dimension: map['dimension'] as String,
      bookedBy: map['bookedBy'] as String,
      startTime: map['startTime'] as Timestamp,
      endTime: map['endTime'] as Timestamp,
      totalPrice: map['totalPrice'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory Room.fromJson(String source) =>
      Room.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Room(uid: $uid, turfId: $turfId, turfName: $turfName, turfAddress: $turfAddress, dimension: $dimension, bookedBy: $bookedBy, startTime: $startTime, endTime: $endTime, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(covariant Room other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.turfId == turfId &&
        other.turfName == turfName &&
        other.turfAddress == turfAddress &&
        other.dimension == dimension &&
        other.bookedBy == bookedBy &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.totalPrice == totalPrice;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        turfId.hashCode ^
        turfName.hashCode ^
        turfAddress.hashCode ^
        dimension.hashCode ^
        bookedBy.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        totalPrice.hashCode;
  }
}
