import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageSliderNotifierProvider =
    NotifierProvider<ImageSliderNotifier, int>(ImageSliderNotifier.new);

class ImageSliderNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void changeIndex({required int index}) {
    state = index;
  }
}
