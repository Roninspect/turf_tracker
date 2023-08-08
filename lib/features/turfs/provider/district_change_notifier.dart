// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/features/auth/provider/user_data_notifer.dart';

final districtChangeNotifierProvider =
    StateNotifierProvider<DistrictChangeNotifier, String>((ref) {
  String initialDistrict =
      ref.watch(userDataNotifierProvider.select((value) => value.district));
  return DistrictChangeNotifier(initialDistrict: initialDistrict);
});

class DistrictChangeNotifier extends StateNotifier<String> {
  String initialDistrict;
  DistrictChangeNotifier({required this.initialDistrict})
      : super(initialDistrict);

  void fetchDiferentDistrict({required String selectedDistrict}) {
    state = selectedDistrict;
  }
}
