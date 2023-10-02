// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Discount {
  final String uid;
  final String userName;
  final num amount;
  Discount({
    required this.uid,
    required this.userName,
    required this.amount,
  });

  Discount copyWith({
    String? uid,
    String? userName,
    num? amount,
  }) {
    return Discount(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userName': userName,
      'amount': amount,
    };
  }

  factory Discount.fromMap(Map<String, dynamic> map) {
    return Discount(
      uid: map['uid'] as String,
      userName: map['userName'] as String,
      amount: map['amount'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory Discount.fromJson(String source) =>
      Discount.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Discount(uid: $uid, userName: $userName, amount: $amount)';

  @override
  bool operator ==(covariant Discount other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.userName == userName &&
        other.amount == amount;
  }

  @override
  int get hashCode => uid.hashCode ^ userName.hashCode ^ amount.hashCode;
}
