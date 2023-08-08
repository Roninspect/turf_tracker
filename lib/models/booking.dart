// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Booking {
  final String bookingId;
  final String bookerid;
  final String bookerName;
  final String turfName;
  final String turfAddress;
  final List<Timestamp> selectedTimeSlots;
  final Timestamp date;
  final String phoneNumber;
  final String transactionId;
  final String paymentId;
  final String paymentDateMade;
  final num totalPrice;
  final num paidInAdvance;
  final num toBePaidInTurf;
  final String turfId;
  Booking({
    required this.bookingId,
    required this.bookerid,
    required this.bookerName,
    required this.turfName,
    required this.turfAddress,
    required this.selectedTimeSlots,
    required this.date,
    required this.phoneNumber,
    required this.transactionId,
    required this.paymentId,
    required this.paymentDateMade,
    required this.totalPrice,
    required this.paidInAdvance,
    required this.toBePaidInTurf,
    required this.turfId,
  });

  Booking copyWith({
    String? bookingId,
    String? bookerid,
    String? bookerName,
    String? turfName,
    String? turfAddress,
    List<Timestamp>? selectedTimeSlots,
    Timestamp? date,
    String? phoneNumber,
    String? transactionId,
    String? paymentId,
    String? paymentDateMade,
    num? totalPrice,
    num? paidInAdvance,
    num? toBePaidInTurf,
    String? turfId,
  }) {
    return Booking(
      bookingId: bookingId ?? this.bookingId,
      bookerid: bookerid ?? this.bookerid,
      bookerName: bookerName ?? this.bookerName,
      turfName: turfName ?? this.turfName,
      turfAddress: turfAddress ?? this.turfAddress,
      selectedTimeSlots: selectedTimeSlots ?? this.selectedTimeSlots,
      date: date ?? this.date,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      transactionId: transactionId ?? this.transactionId,
      paymentId: paymentId ?? this.paymentId,
      paymentDateMade: paymentDateMade ?? this.paymentDateMade,
      totalPrice: totalPrice ?? this.totalPrice,
      paidInAdvance: paidInAdvance ?? this.paidInAdvance,
      toBePaidInTurf: toBePaidInTurf ?? this.toBePaidInTurf,
      turfId: turfId ?? this.turfId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bookingId': bookingId,
      'bookerid': bookerid,
      'bookerName': bookerName,
      'turfName': turfName,
      'turfAddress': turfAddress,
      'selectedTimeSlots': selectedTimeSlots.map((x) => x).toList(),
      'date': date,
      'phoneNumber': phoneNumber,
      'transactionId': transactionId,
      'paymentId': paymentId,
      'paymentDateMade': paymentDateMade,
      'totalPrice': totalPrice,
      'paidInAdvance': paidInAdvance,
      'toBePaidInTurf': toBePaidInTurf,
      'turfId': turfId,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      bookingId: map['bookingId'] as String,
      bookerid: map['bookerid'] as String,
      bookerName: map['bookerName'] as String,
      turfName: map['turfName'] as String,
      turfAddress: map['turfAddress'] as String,
      selectedTimeSlots: List<Timestamp>.from(
        (map['selectedTimeSlots'] as List<dynamic>).map<Timestamp>(
          (x) => x as Timestamp,
        ),
      ),
      date: map['date'] as Timestamp,
      phoneNumber: map['phoneNumber'] as String,
      transactionId: map['transactionId'] as String,
      paymentId: map['paymentId'] as String,
      paymentDateMade: map['paymentDateMade'] as String,
      totalPrice: map['totalPrice'] as num,
      paidInAdvance: map['paidInAdvance'] as num,
      toBePaidInTurf: map['toBePaidInTurf'] as num,
      turfId: map['turfId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Booking.fromJson(String source) =>
      Booking.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Booking(bookingId: $bookingId, bookerid: $bookerid, bookerName: $bookerName, turfName: $turfName, turfAddress: $turfAddress, selectedTimeSlots: $selectedTimeSlots, date: $date, phoneNumber: $phoneNumber, transactionId: $transactionId, paymentId: $paymentId, paymentDateMade: $paymentDateMade, totalPrice: $totalPrice, paidInAdvance: $paidInAdvance, toBePaidInTurf: $toBePaidInTurf, turfId: $turfId)';
  }

  @override
  bool operator ==(covariant Booking other) {
    if (identical(this, other)) return true;

    return other.bookingId == bookingId &&
        other.bookerid == bookerid &&
        other.bookerName == bookerName &&
        other.turfName == turfName &&
        other.turfAddress == turfAddress &&
        listEquals(other.selectedTimeSlots, selectedTimeSlots) &&
        other.date == date &&
        other.phoneNumber == phoneNumber &&
        other.transactionId == transactionId &&
        other.paymentId == paymentId &&
        other.paymentDateMade == paymentDateMade &&
        other.totalPrice == totalPrice &&
        other.paidInAdvance == paidInAdvance &&
        other.toBePaidInTurf == toBePaidInTurf &&
        other.turfId == turfId;
  }

  @override
  int get hashCode {
    return bookingId.hashCode ^
        bookerid.hashCode ^
        bookerName.hashCode ^
        turfName.hashCode ^
        turfAddress.hashCode ^
        selectedTimeSlots.hashCode ^
        date.hashCode ^
        phoneNumber.hashCode ^
        transactionId.hashCode ^
        paymentId.hashCode ^
        paymentDateMade.hashCode ^
        totalPrice.hashCode ^
        paidInAdvance.hashCode ^
        toBePaidInTurf.hashCode ^
        turfId.hashCode;
  }
}
