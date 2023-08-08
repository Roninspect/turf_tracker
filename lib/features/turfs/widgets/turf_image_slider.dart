// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:turf_tracker/models/turf.dart';

import '../provider/image_slider_index.dart';

class TurfImageSlider extends ConsumerWidget {
  final Turf turf;
  const TurfImageSlider({
    super.key,
    required this.turf,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      CarouselSlider.builder(
        itemCount: turf.images.length,
        itemBuilder: (context, index, realIndex) {
          final singleImage = turf.images[index];
          return Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(singleImage, maxWidth: 500),
                ),
              ),
            ),
          );
        },
        options: CarouselOptions(
          clipBehavior: Clip.none,
          viewportFraction: 1,
          onPageChanged: (index, reason) {
            ref
                .read(imageSliderNotifierProvider.notifier)
                .changeIndex(index: index);
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: DotsIndicator(
          dotsCount: turf.images.length,
          position: ref.watch(imageSliderNotifierProvider),
          decorator: const DotsDecorator(
              activeColor: Colors.white, activeShape: LinearBorder()),
          // position: index,
        ),
      )
    ]);
  }
}
