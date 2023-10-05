import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:turf_tracker/models/icon.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String address;
  String district;
  String phoneNumber;
  String profilePic;
  bool hasGivenReview;
  bool hasGivenFeedback;
  bool hasClosed;
  num rewardsPoint;
  num bookingsNo;
  List<IconModel> interestedSports;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.address,
    required this.district,
    required this.phoneNumber,
    required this.profilePic,
    required this.hasGivenReview,
    required this.hasGivenFeedback,
    required this.hasClosed,
    required this.rewardsPoint,
    required this.bookingsNo,
    required this.interestedSports,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? address,
    String? district,
    String? phoneNumber,
    String? profilePic,
    bool? hasGivenReview,
    bool? hasGivenFeedback,
    bool? hasClosed,
    num? rewardsPoint,
    num? bookingsNo,
    List<IconModel>? interestedSports,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      district: district ?? this.district,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePic: profilePic ?? this.profilePic,
      hasGivenReview: hasGivenReview ?? this.hasGivenReview,
      hasGivenFeedback: hasGivenFeedback ?? this.hasGivenFeedback,
      hasClosed: hasClosed ?? this.hasClosed,
      rewardsPoint: rewardsPoint ?? this.rewardsPoint,
      bookingsNo: bookingsNo ?? this.bookingsNo,
      interestedSports: interestedSports ?? this.interestedSports,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'address': address,
      'district': district,
      'phoneNumber': phoneNumber,
      'profilePic': profilePic,
      'hasGivenReview': hasGivenReview,
      "hasGivenFeedback": hasGivenFeedback,
      "hasClosed": hasClosed,
      'rewardsPoint': rewardsPoint,
      'bookingsNo': bookingsNo,
      'interestedSports': interestedSports.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      district: map['district'] as String,
      phoneNumber: map['phoneNumber'] as String,
      profilePic: map['profilePic'] as String,
      hasGivenReview: map['hasGivenReview'] as bool,
      hasGivenFeedback: map['hasGivenFeedback'] as bool,
      hasClosed: map['hasClosed'] as bool,
      rewardsPoint: map['rewardsPoint'] as num,
      bookingsNo: map['bookingsNo'] as num,
      interestedSports: List<IconModel>.from(
          (map['interestedSports'] as List<dynamic>)
              .map((e) => IconModel.fromMap(e as Map<String, dynamic>))),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.address == address &&
        other.district == district &&
        other.phoneNumber == phoneNumber &&
        other.profilePic == profilePic &&
        other.hasGivenReview == hasGivenReview &&
        other.hasGivenFeedback == hasGivenFeedback &&
        other.hasClosed == hasClosed &&
        other.rewardsPoint == rewardsPoint &&
        other.bookingsNo == bookingsNo &&
        listEquals(other.interestedSports, interestedSports);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        address.hashCode ^
        district.hashCode ^
        phoneNumber.hashCode ^
        profilePic.hashCode ^
        hasGivenReview.hashCode ^
        hasGivenFeedback.hashCode ^
        hasClosed.hashCode ^
        rewardsPoint.hashCode ^
        bookingsNo.hashCode ^
        interestedSports.hashCode;
  }
}
