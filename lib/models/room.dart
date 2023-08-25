// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String roomId;
  final String uid;
  final String joinedBy;
  final String joinedByName;
  final String joinedByNumber;
  final bool isActive;
  final bool isLocked;
  final String bookerNumber;
  final String bookingId;
  final String turfId;
  final String turfName;
  final String turfAddress;
  final String dimension;
  final String bookedBy;
  final Timestamp startTime;
  final Timestamp endTime;
  final num totalPrice;
  final String district;

  Room(
      {required this.roomId,
      required this.uid,
      required this.joinedBy,
      required this.joinedByName,
      required this.joinedByNumber,
      required this.isActive,
      required this.bookerNumber,
      required this.bookingId,
      required this.turfId,
      required this.turfName,
      required this.turfAddress,
      required this.dimension,
      required this.bookedBy,
      required this.startTime,
      required this.endTime,
      required this.totalPrice,
      required this.district,
      required this.isLocked});

  Room copyWith(
      {String? roomId,
      String? uid,
      String? joinedBy,
      String? joinedByName,
      String? joinedByNumber,
      bool? isActive,
      bool? isLocked,
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
      String? bookingId}) {
    return Room(
      roomId: roomId ?? this.roomId,
      uid: uid ?? this.uid,
      joinedBy: joinedBy ?? this.joinedBy,
      joinedByName: joinedByName ?? this.joinedByName,
      joinedByNumber: joinedByNumber ?? this.joinedByNumber,
      isActive: isActive ?? this.isActive,
      isLocked: isLocked ?? this.isLocked,
      bookerNumber: bookerNumber ?? this.bookerNumber,
      bookingId: bookingId ?? this.bookingId,
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
      'joinedBy': joinedBy,
      'joinedByName': joinedByName,
      'joinedByNumber': joinedByNumber,
      'isActive': isActive,
      "isLocked": isLocked,
      'bookerNumber': bookerNumber,
      "bookingId": bookingId,
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
      joinedBy: map['joinedBy'] as String,
      joinedByName: map['joinedByName'] as String,
      joinedByNumber: map['joinedByNumber'] as String,
      isActive: map['isActive'] as bool,
      isLocked: map["isLocked"] as bool,
      bookerNumber: map['bookerNumber'] as String,
      bookingId: map['bookingId'] as String,
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
        other.joinedBy == joinedBy &&
        other.joinedByName == joinedByName &&
        other.joinedByNumber == joinedByNumber &&
        other.isActive == isActive &&
        other.bookerNumber == bookerNumber &&
        other.bookingId == bookingId &&
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
        joinedBy.hashCode ^
        joinedByName.hashCode ^
        joinedByNumber.hashCode ^
        isActive.hashCode ^
        bookerNumber.hashCode ^
        bookingId.hashCode ^
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
