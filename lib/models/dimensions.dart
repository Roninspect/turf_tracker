class Dimensions {
  String did;
  String tid;
  String length;
  String width;
  String height;
  String whatBywhat;
  String dimentionsPhotoUrl;
  String aVSb;
  List<String> sports;
  Dimensions({
    required this.did,
    required this.tid,
    required this.length,
    required this.width,
    required this.height,
    required this.whatBywhat,
    required this.dimentionsPhotoUrl,
    required this.aVSb,
    required this.sports,
  });

  Dimensions copyWith({
    String? did,
    String? tid,
    String? length,
    String? width,
    String? height,
    String? whatBywhat,
    String? dimentionsPhotoUrl,
    String? aVSb,
    List<String>? sports,
  }) {
    return Dimensions(
      did: did ?? this.did,
      tid: tid ?? this.tid,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      whatBywhat: whatBywhat ?? this.whatBywhat,
      dimentionsPhotoUrl: dimentionsPhotoUrl ?? this.dimentionsPhotoUrl,
      aVSb: aVSb ?? this.aVSb,
      sports: sports ?? this.sports,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "did": did,
      "tid": tid,
      'length': length,
      'width': width,
      'height': height,
      'whatByWhat': whatBywhat,
      'dimentionsPhotoUrl': dimentionsPhotoUrl,
      "aVSb": aVSb,
      'sports': sports,
    };
  }

  factory Dimensions.fromMap(Map<String, dynamic> map) {
    return Dimensions(
      did: map['did'] as String,
      tid: map['tid'] as String,
      length: map['length'] as String,
      width: map['width'] as String,
      height: map['height'] as String,
      whatBywhat: map['whatByWhat'] as String,
      dimentionsPhotoUrl: map['dimentionsPhotoUrl'] as String,
      aVSb: map["aVSb"] as String,
      sports: List<String>.from((map['sports'] as List<dynamic>).map((e) => e)),
    );
  }
}
