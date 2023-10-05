// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/common/fav_butoon.dart';
import 'package:turf_tracker/features/turfs/widgets/turf_image_slider.dart';
import 'package:turf_tracker/models/turf.dart';

class TurfBlock extends ConsumerWidget {
  final Turf turf;
  final bool showSlider;
  const TurfBlock({
    super.key,
    required this.turf,
    required this.showSlider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //** calculating avg rating */
    num getAverageRating() {
      if (turf.ratings.isEmpty) {
        return 0.0; // Return 0 if there are no ratings
      }

      // Calculate the sum of all ratings in the list
      num totalRating =
          turf.ratings.map((rating) => rating.rating).reduce((a, b) => a + b);

      // Calculate the average by dividing the total rating by the number of ratings
      num avgRating = totalRating / turf.ratings.length;
      return avgRating;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: cardColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            showSlider
                ? Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: TurfImageSlider(turf: turf))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        imageUrl: turf.images.first,
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        turf.name,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FavButton(turf: turf)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(turf.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                            )),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          Text(
                            "${getAverageRating().toStringAsFixed(2)} ",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
