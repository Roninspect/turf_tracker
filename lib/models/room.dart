// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String roomId;
  final String uid;
  final bool isActive;
  final String bookerNumber;
  final String turfId;
  final String turfName;
  final String turfAddress;
  final String dimension;
  final String bookedBy;
  final Timestamp startTime;
  final Timestamp endTime;
  final num totalPrice;
  final String district;
  Room({
    required this.roomId,
    required this.uid,
    required this.isActive,
    required this.bookerNumber,
    required this.turfId,
    required this.turfName,
    required this.turfAddress,
    required this.dimension,
    required this.bookedBy,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.district,
  });

  Room copyWith({
    String? roomId,
    String? uid,
    bool? isActive,
    String? bookerNumber,
    String? turfId,
    String? turfName,
    String? turfAddress,
    String? dimension,
    String? bookedBy,
    Timestamp? startTime,
    Timestamp? endTime,
    num? totalPrice,
    String? district,
  }) {
    return Room(
      roomId: roomId ?? this.roomId,
      uid: uid ?? this.uid,
      isActive: isActive ?? this.isActive,
      bookerNumber: bookerNumber ?? this.bookerNumber,
      turfId: turfId ?? this.turfId,
      turfName: turfName ?? this.turfName,
      turfAddress: turfAddress ?? this.turfAddress,
      dimension: dimension ?? this.dimension,
      bookedBy: bookedBy ?? this.bookedBy,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalPrice: totalPrice ?? this.totalPrice,
      district: district ?? this.district,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomId': roomId,
      'uid': uid,
      'isActive': isActive,
      'bookerNumber': bookerNumber,
      'turfId': turfId,
      'turfName': turfName,
      'turfAddress': turfAddress,
      'dimension': dimension,
      'bookedBy': bookedBy,
      'startTime': startTime,
      'endTime': endTime,
      'totalPrice': totalPrice,
      'district': district,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      roomId: map['roomId'] as String,
      uid: map['uid'] as String,
      isActive: map['isActive'] as bool,
      bookerNumber: map['bookerNumber'] as String,
      turfId: map['turfId'] as String,
      turfName: map['turfName'] as String,
      turfAddress: map['turfAddress'] as String,
      dimension: map['dimension'] as String,
      bookedBy: map['bookedBy'] as String,
      startTime: map['startTime'] as Timestamp,
      endTime: map['endTime'] as Timestamp,
      totalPrice: map['totalPrice'] as num,
      district: map['district'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Room.fromJson(String source) =>
      Room.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Room(roomId: $roomId, uid: $uid, isActive: $isActive, bookerNumber: $bookerNumber, turfId: $turfId, turfName: $turfName, turfAddress: $turfAddress, dimension: $dimension, bookedBy: $bookedBy, startTime: $startTime, endTime: $endTime, totalPrice: $totalPrice, district: $district)';
  }

  @override
  bool operator ==(covariant Room other) {
    if (identical(this, other)) return true;

    return other.roomId == roomId &&
        other.uid == uid &&
        other.isActive == isActive &&
        other.bookerNumber == bookerNumber &&
        other.turfId == turfId &&
        other.turfName == turfName &&
        other.turfAddress == turfAddress &&
        other.dimension == dimension &&
        other.bookedBy == bookedBy &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.totalPrice == totalPrice &&
        other.district == district;
  }

  @override
  int get hashCode {
    return roomId.hashCode ^
        uid.hashCode ^
        isActive.hashCode ^
        bookerNumber.hashCode ^
        turfId.hashCode ^
        turfName.hashCode ^
        turfAddress.hashCode ^
        dimension.hashCode ^
        bookedBy.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        totalPrice.hashCode ^
        district.hashCode;
  }
}
