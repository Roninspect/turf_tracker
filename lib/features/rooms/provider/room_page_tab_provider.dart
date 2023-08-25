import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainRoomTabIndexNotifier extends Notifier<int> {
  @override
  build() {
    return 0;
  }

  void changeIndex({required int selectedValue}) {
    state = selectedValue;
  }
}

final mainroomTabIndexNotifierProvider =
    NotifierProvider<MainRoomTabIndexNotifier, int>(
        MainRoomTabIndexNotifier.new);
