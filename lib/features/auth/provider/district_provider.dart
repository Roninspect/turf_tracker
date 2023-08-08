import 'package:flutter_riverpod/flutter_riverpod.dart';

enum District {
  Dhaka,
  Chittagong,
}

final registerDistrictSelectingNotifierProvider =
    NotifierProvider<RegisterDistrictSelectingNotifier, String>(
        RegisterDistrictSelectingNotifier.new);

class RegisterDistrictSelectingNotifier extends Notifier<String> {
  @override
  build() {
    return District.Chittagong.name;
  }

  void changeDistrict({required String selectedDistrict}) {
    state = selectedDistrict;
  }
}
