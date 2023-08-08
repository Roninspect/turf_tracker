// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_tracker/features/auth/provider/user_data_notifer.dart';
import '../../../common/colors.dart';
import '../../../models/rating.dart';
import '../controller/turf_controller.dart';
import '../provider/user_given_review_provider.dart';

class GiveReviewCard extends ConsumerStatefulWidget {
  final String turfId;
  const GiveReviewCard({
    super.key,
    required this.turfId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GiveReviewCardState();
}

class _GiveReviewCardState extends ConsumerState<GiveReviewCard> {
  TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRating = ref.watch(userGivenRatingNotifierProvider);
    final user = ref.watch(userDataNotifierProvider);

    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white10,
        child: Column(
          children: [
            const Text(
              "How Was Your Experience?",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            RatingBar(
              initialRating: 0,
              minRating: 0,
              maxRating: 5,
              allowHalfRating: true,
              ratingWidget: RatingWidget(
                full: const Icon(Icons.star, color: greenColor),
                half: const Icon(Icons.star_half, color: greenColor),
                empty: const Icon(Icons.star_border, color: greenColor),
              ),
              onRatingUpdate: (value) {
                ref
                    .read(userGivenRatingNotifierProvider.notifier)
                    .giveRating(givenRating: value);
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: commentController,
              maxLength: 100,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Give a review (optional)",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: greenColor),
                onPressed: () {
                  //** initializing rating */

                  final rating = Rating(
                      uid: user.uid,
                      rating: userRating,
                      comment: commentController.text,
                      username: user.name,
                      timestamp: Timestamp.now(),
                      profile: user.profilePic);
                  //** saving the rating to firestore */
                  ref.read(turfControllerProvider).rateATurf(
                      turfId: widget.turfId, rating: rating, context: context);
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
