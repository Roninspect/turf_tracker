// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class IconModel {
  final String iconId;
  final String iconLink;
  final String iconName;
  IconModel({
    required this.iconId,
    required this.iconLink,
    required this.iconName,
  });

  IconModel copyWith({
    String? iconId,
    String? iconLink,
    String? iconName,
  }) {
    return IconModel(
      iconId: iconId ?? this.iconId,
      iconLink: iconLink ?? this.iconLink,
      iconName: iconName ?? this.iconName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'iconId': iconId,
      'iconLink': iconLink,
      'iconName': iconName,
    };
  }

  factory IconModel.fromMap(Map<String, dynamic> map) {
    return IconModel(
      iconId: map['iconId'] as String,
      iconLink: map['iconLink'] as String,
      iconName: map['iconName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory IconModel.fromJson(String source) =>
      IconModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'IconModel(iconId: $iconId, iconLink: $iconLink, iconName: $iconName)';

  @override
  bool operator ==(covariant IconModel other) {
    if (identical(this, other)) return true;

    return other.iconId == iconId &&
        other.iconLink == iconLink &&
        other.iconName == iconName;
  }

  @override
  int get hashCode => iconId.hashCode ^ iconLink.hashCode ^ iconName.hashCode;
}
