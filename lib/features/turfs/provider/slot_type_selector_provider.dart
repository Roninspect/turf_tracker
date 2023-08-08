import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SlotType {
  oneHourAvailibilty,
  oneHalfHourAvailibilty,
}

final slotTypeNotifierProvider =
    NotifierProvider<SlotTypeNotifier, SlotType?>(SlotTypeNotifier.new);

class SlotTypeNotifier extends Notifier<SlotType?> {
  @override
  build() {
    return null;
  }

  void selectSlotType({required SlotType slotType}) {
    state = slotType;
  }
}
