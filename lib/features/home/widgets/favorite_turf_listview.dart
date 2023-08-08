import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_tracker/features/home/controller/home_controller.dart';
import 'package:turf_tracker/features/root/provider/nav_controller.dart';
import 'package:turf_tracker/models/turf.dart';

import '../../../models/favorites.dart';
import '../../../router/router.dart';
import '../../turfs/widgets/turf_block.dart';

class FavoriteTurfListView extends ConsumerWidget {
  const FavoriteTurfListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 350,
      child: ref.watch(getFavoriteByUidProvider).when(
            data: (favorites) {
              List<Turf> data = []; // Default empty list

              for (Favorite favorite in favorites) {
                ref.watch(getFavoriteProvider(favorite.turfId)).when(
                      data: (turfData) {
                        // Update the 'data' list as data becomes available
                        data.addAll(turfData);

                        // Return an empty Container for now (it will be replaced by the ListView later)
                        return Container();
                      },
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () => const CircularProgressIndicator(),
                    );
              }

              // After the loop, the 'data' list should be updated with all the Turf items.
              return data.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("You haven't favorited any turf"),
                          TextButton(
                              onPressed: () {
                                ref
                                    .read(navNotifierProvider.notifier)
                                    .navStateChange(1);
                              },
                              child: const Text("Go on favorite some"))
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: data.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final Turf turf = data[index];
                        return GestureDetector(
                          onTap: () {
                            String name = turf.name;
                            context.pushNamed(
                              AppRoutes.turfDetails.name,
                              pathParameters: {"name": name},
                              extra: turf,
                            );
                          },
                          child: SizedBox(
                              width: 360,
                              child: TurfBlock(
                                turf: turf,
                                showSlider: false,
                              )),
                        );
                      },
                    );
            },
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
