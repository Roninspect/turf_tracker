// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Availibilty extends Equatable {
  final String timeId;
  final String turfId;
  final String did;
  final String status;
  final Timestamp date;
  final String dimension;
  final List<TimeTable> oneHalfHourAvailibilty;
  final List<TimeTable> oneHourAvailibilty;
  const Availibilty({
    required this.timeId,
    required this.turfId,
    required this.did,
    required this.status,
    required this.date,
    required this.dimension,
    required this.oneHalfHourAvailibilty,
    required this.oneHourAvailibilty,
  });

  Availibilty copyWith({
    String? timeId,
    String? turfId,
    String? did,
    String? status,
    Timestamp? date,
    String? dimension,
    List<TimeTable>? oneHalfHourAvailibilty,
    List<TimeTable>? oneHourAvailibilty,
  }) {
    return Availibilty(
      timeId: timeId ?? this.timeId,
      turfId: turfId ?? this.turfId,
      did: did ?? this.did,
      status: status ?? this.status,
      date: date ?? this.date,
      dimension: dimension ?? this.dimension,
      oneHalfHourAvailibilty:
          oneHalfHourAvailibilty ?? this.oneHalfHourAvailibilty,
      oneHourAvailibilty: oneHourAvailibilty ?? this.oneHourAvailibilty,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "timeId": timeId,
      'turfId': turfId,
      'did': did,
      'status': status,
      'date': date,
      "dimension": dimension,
      'oneHalfHourAvailability':
          oneHalfHourAvailibilty.map((x) => x.toMap()).toList(),
      'oneHourAvailibilty': oneHourAvailibilty.map((x) => x.toMap()).toList(),
    };
  }

  factory Availibilty.fromMap(Map<String, dynamic> map) {
    return Availibilty(
      timeId: map["timeId"] as String,
      turfId: map['turfId'] as String,
      did: map['did'] as String,
      status: map['status'] as String,
      date: map['date'] as Timestamp,
      dimension: map["dimension"] as String,
      oneHalfHourAvailibilty: List<TimeTable>.from(
        (map['oneHalfHourAvailability'] as List<dynamic>).map<TimeTable>(
          (x) => TimeTable.fromMap(x as Map<String, dynamic>),
        ),
      ),
      oneHourAvailibilty: List<TimeTable>.from(
        (map['oneHourAvailibilty'] as List<dynamic>).map<TimeTable>(
          (x) => TimeTable.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Availibilty.fromJson(String source) =>
      Availibilty.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        timeId,
        turfId,
        did,
        status,
        date,
        dimension,
        ...oneHalfHourAvailibilty,
        ...oneHourAvailibilty,
      ];
}

// ignore: must_be_immutable
class TimeTable extends Equatable {
  bool isAvailable;
  bool isLocked;
  num price;
  Timestamp startTime;
  Timestamp endTime;
  TimeTable({
    required this.isAvailable,
    required this.isLocked,
    required this.price,
    required this.startTime,
    required this.endTime,
  });

  TimeTable copyWith({
    bool? isAvailable,
    bool? isLocked,
    num? price,
    Timestamp? startTime,
    Timestamp? endTime,
  }) {
    return TimeTable(
      isAvailable: isAvailable ?? this.isAvailable,
      isLocked: isLocked ?? this.isLocked,
      price: price ?? this.price,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isAvailable': isAvailable,
      'isLocked': isLocked,
      'price': price,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory TimeTable.fromMap(Map<String, dynamic> map) {
    return TimeTable(
      isAvailable: map['isAvailable'] as bool,
      isLocked: map['isLocked'] as bool,
      price: map['price'] as num,
      startTime: map['startTime'] as Timestamp,
      endTime: map['endTime'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeTable.fromJson(String source) =>
      TimeTable.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [isAvailable, isLocked, price, startTime, endTime];
}
