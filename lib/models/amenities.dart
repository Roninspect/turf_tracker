class Amenities {
  String amenitiesName;
  String iconUrl;
  Amenities({
    required this.amenitiesName,
    required this.iconUrl,
  });

  Amenities copyWith({
    String? amenitiesName,
    String? iconUrl,
  }) {
    return Amenities(
      amenitiesName: amenitiesName ?? this.amenitiesName,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amenitiesName': amenitiesName,
      'iconUrl': iconUrl,
    };
  }

  factory Amenities.fromMap(Map<String, dynamic> map) {
    return Amenities(
      amenitiesName: map['amenitiesName'] as String,
      iconUrl: map['iconUrl'] as String,
    );
  }
}
