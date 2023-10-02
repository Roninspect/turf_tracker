import 'package:turf_tracker/models/discount.dart';
import 'package:turf_tracker/models/rating.dart';

import 'amenities.dart';

class Turf {
  String name;
  String turfId;
  String description;
  String district;
  String startWeekday;
  String endWeekday;
  String startTime;
  String endTime;
  String address;
  String latitude;
  String longitude;
  String startingPrice;
  String maximumPrice;
  num commission_percentage;
  List<Rating> ratings;
  List<String> sportsAllowed;
  List<Amenities> amenities;
  List<String> images;
  List<Discount> discounts;
  Turf({
    required this.name,
    required this.turfId,
    required this.description,
    required this.district,
    required this.startWeekday,
    required this.endWeekday,
    required this.startTime,
    required this.endTime,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.startingPrice,
    required this.maximumPrice,
    required this.commission_percentage,
    required this.ratings,
    required this.sportsAllowed,
    required this.amenities,
    required this.images,
    required this.discounts,
  });

  Turf copyWith({
    String? name,
    String? turfId,
    String? description,
    String? district,
    String? startWeekday,
    String? endWeekday,
    String? startTime,
    String? endTime,
    String? address,
    String? latitude,
    String? longitude,
    String? startingPrice,
    String? maximumPrice,
    num? commission_percentage,
    List<Rating>? ratings,
    List<String>? sportsAllowed,
    List<Amenities>? amenities,
    List<String>? images,
    List<Discount>? discounts,
  }) {
    return Turf(
      name: name ?? this.name,
      turfId: turfId ?? this.turfId,
      description: description ?? this.description,
      district: district ?? this.district,
      startWeekday: startWeekday ?? this.startWeekday,
      endWeekday: endWeekday ?? this.endWeekday,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      commission_percentage:
          commission_percentage ?? this.commission_percentage,
      ratings: ratings ?? this.ratings,
      startingPrice: startingPrice ?? this.startingPrice,
      maximumPrice: maximumPrice ?? this.maximumPrice,
      sportsAllowed: sportsAllowed ?? this.sportsAllowed,
      amenities: amenities ?? this.amenities,
      images: images ?? this.images,
      discounts: discounts ?? this.discounts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'turfId': turfId,
      "description": description,
      'district': district,
      'startWeekday': startWeekday,
      'endWeekday': endWeekday,
      'startTime': startTime,
      'endTime': endTime,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "startingPrice": startingPrice,
      "maximumPrice": maximumPrice,
      "commission_percentage": commission_percentage,
      "ratings": ratings.map((e) => e.toMap()).toList(),
      'sportsAllowed': sportsAllowed,
      'amenities': amenities.map((x) => x.toMap()).toList(),
      'images': images,
      "discounts": discounts,
    };
  }

  factory Turf.fromMap(Map<String, dynamic> map) {
    return Turf(
      name: map['name'] as String,
      turfId: map['turfId'] as String,
      description: map["description"] as String,
      district: map['district'] as String,
      startWeekday: map['startWeekday'] as String,
      endWeekday: map['endWeekday'] as String,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      address: map['address'] as String,
      latitude: map["latitude"] as String,
      longitude: map['longitude'] as String,
      startingPrice: map['startingPrice'] as String,
      maximumPrice: map['maximumPrice'] as String,
      commission_percentage: map['commission_percentage'] as num,
      ratings: List<Rating>.from(
        (map['ratings'] as List<dynamic>).map<Rating>(
          (x) => Rating.fromMap(x as Map<String, dynamic>),
        ),
      ),
      sportsAllowed: List<String>.from(
          (map['sportsAllowed'] as List<dynamic>).map((e) => e)),
      amenities: List<Amenities>.from(
        (map['amenities'] as List<dynamic>).map<Amenities>(
          (x) => Amenities.fromMap(x as Map<String, dynamic>),
        ),
      ),
      images: List<String>.from(
        (map['images'] as List<dynamic>).map((e) => e),
      ),
      discounts: List<Discount>.from(
        (map['discounts'] as List<dynamic>).map<Discount>(
          (x) => Discount.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
