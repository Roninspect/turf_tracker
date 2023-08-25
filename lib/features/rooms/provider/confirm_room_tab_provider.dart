import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomTabIndexNotifier extends Notifier<int> {
  @override
  build() {
    return 0;
  }

  void changeIndex({required int selectedValue}) {
    state = selectedValue;
  }
}

final roomTabIndexNotifierProvider =
    NotifierProvider<RoomTabIndexNotifier, int>(RoomTabIndexNotifier.new);
