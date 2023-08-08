import 'package:flutter_riverpod/flutter_riverpod.dart';

final navNotifierProvider =
    NotifierProvider<NavNotifier, int>(() => NavNotifier());

class NavNotifier extends Notifier<int> {
  @override
  build() {
    return 0;
  }

  void navStateChange(int index) {
    state = index;
  }
}
