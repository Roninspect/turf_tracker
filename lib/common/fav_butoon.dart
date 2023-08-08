// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/turfs/controller/turf_controller.dart';
import '../models/turf.dart';
import 'colors.dart';

class FavButton extends ConsumerWidget {
  final Turf turf;

  const FavButton({
    super.key,
    required this.turf,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(isFavoritedProvider(turf.turfId)).when(
        data: (data) {
          if (data.isEmpty) {
            return IconButton(
                onPressed: () {
                  ref
                      .read(turfControllerProvider)
                      .favoriteATurf(turfId: turf.turfId);
                },
                icon: const Icon(
                  Icons.favorite_outline,
                  color: greenColor,
                  size: 35,
                ));
          } else {
            return IconButton(
                onPressed: () {
                  ref
                      .read(turfControllerProvider)
                      .unFavoriteATurf(turfId: turf.turfId);
                },
                icon: const Icon(
                  Icons.favorite,
                  color: greenColor,
                  size: 35,
                ));
          }
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const CircularProgressIndicator());
  }
}
