import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_tracker/features/turfs/widgets/turf_block.dart';
import 'package:turf_tracker/router/router.dart';

import '../../../models/turf.dart';
import '../controller/turf_controller.dart';
import '../provider/district_change_notifier.dart';

class TurfsListView extends ConsumerWidget {
  const TurfsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDistrict = ref.watch(districtChangeNotifierProvider);
    return ref
        .watch(fetchTurfByAlreadySelectedDistrictProvider(selectedDistrict))
        .when(
          data: (turfs) {
            return turfs.isEmpty
                ? const Center(
                    child: Text("No Turfs in your City"),
                  )
                : ListView.builder(
                    itemCount: turfs.length,
                    itemBuilder: (context, index) {
                      final Turf turf = turfs[index];
                      return GestureDetector(
                          onTap: () {
                            String name = turf.name;
                            context.pushNamed(
                              AppRoutes.turfDetails.name,
                              pathParameters: {"name": name},
                              extra: turf,
                            );
                          },
                          child: TurfBlock(
                            turf: turf,
                            showSlider: true,
                          ));
                    },
                  );
          },
          error: (error, stackTrace) {
            if (kDebugMode) {
              print(stackTrace);
            }
            return Center(
              child: Text(error.toString()),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}
