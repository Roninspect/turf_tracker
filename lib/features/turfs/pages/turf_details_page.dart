import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:readmore/readmore.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/common/custom_snackbar.dart';
import 'package:turf_tracker/features/auth/provider/user_data_notifer.dart';
import 'package:turf_tracker/features/turfs/provider/sports_selection_provider.dart';
import 'package:turf_tracker/features/turfs/widgets/chip.dart';
import 'package:turf_tracker/features/turfs/widgets/dimension_listview.dart';
import 'package:turf_tracker/features/turfs/provider/dimension_selector_provider.dart';
import 'package:turf_tracker/features/turfs/widgets/give_review_block.dart';
import 'package:turf_tracker/models/rating.dart';
import 'package:turf_tracker/router/router.dart';
import '../../../models/turf.dart';
import '../controller/turf_controller.dart';
import '../widgets/turf_image_slider.dart';

class TurfDetailsPage extends ConsumerStatefulWidget {
  final Turf turf;
  final String turfName;
  const TurfDetailsPage({
    super.key,
    required this.turf,
    required this.turfName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TurfDetailsPageState();
}

class _TurfDetailsPageState extends ConsumerState<TurfDetailsPage> {
  //*** maps fi=unctionalities */
  List<AvailableMap> availableMaps = [];
  Future<void> getAvailableMaps() async {
    final availableMap = await MapLauncher.installedMaps;
    setState(() {
      availableMaps = availableMap;
    });
  }

  @override
  void initState() {
    super.initState();
    getAvailableMaps();
  }

  @override
  Widget build(BuildContext context) {
    int selectedSportsIndex = ref.watch(sportsSelectionNotifierProvider);
    final String selectedSports =
        widget.turf.sportsAllowed[selectedSportsIndex];
    final selectedDimension = ref.watch(dimensionSelectionNotifierProvider);

    final user = ref.watch(userDataNotifierProvider);

    //** calculating avg rating */
    num getAverageRating() {
      if (widget.turf.ratings.isEmpty) {
        return 0.0; // Return 0 if there are no ratings
      }

      // Calculate the sum of all ratings in the list
      num totalRating = widget.turf.ratings
          .map((rating) => rating.rating)
          .reduce((a, b) => a + b);

      // Calculate the average by dividing the total rating by the number of ratings
      num avgRating = totalRating / widget.turf.ratings.length;
      return avgRating;
    }

    //** formating ratings length */
    String formattedLength =
        widget.turf.ratings.length.toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(72, 203, 74, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //** turf Image slider */
              TurfImageSlider(turf: widget.turf),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.turf.name,
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 270,
                        child: Text(widget.turf.address,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          availableMaps.first.showMarker(
                              coords: Coords(double.parse(widget.turf.latitude),
                                  double.parse(widget.turf.longitude)),
                              title: widget.turfName);
                        },
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Icon(
                              Fontisto.map_marker_alt,
                              color: greenColor,
                            )),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          Text(
                            getAverageRating().toStringAsFixed(2),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            " ($formattedLength)",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ReadMoreText(
                widget.turf.description,
                trimLines: 2,
                colorClickableText: Colors.pink,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: greenColor),
                lessStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: greenColor),
              ),
              const SizedBox(height: 20),

              //* basic information list of the turf
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CustomChip(
                      first: widget.turf.startWeekday,
                      second: widget.turf.endWeekday,
                      icon: AntDesign.calendar,
                    ),
                    CustomChip(
                      first: widget.turf.startTime,
                      second: widget.turf.endTime,
                      icon: AntDesign.clockcircleo,
                    ),
                    CustomChip(
                      first: "BDT ${widget.turf.startingPrice}",
                      second: "BDT ${widget.turf.maximumPrice}",
                      icon: MaterialCommunityIcons.currency_bdt,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Amenities: ",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.turf.amenities.length,
                  itemBuilder: (context, index) {
                    final amenity = widget.turf.amenities[index];

                    return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Column(
                          children: [
                            Image.network(
                              amenity.iconUrl,
                              height: 30,
                              color: greenColor,
                            ),
                            Text(amenity.amenitiesName),
                          ],
                        ));
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Sports Allowed to play: ",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              //* Sports that allowed to play
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.turf.sportsAllowed.length,
                  itemBuilder: (context, index) {
                    final String sport = widget.turf.sportsAllowed[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          ref
                              .read(sportsSelectionNotifierProvider.notifier)
                              .changeSports(selectedSports: index);
                          ref
                              .read(dimensionSelectionNotifierProvider.notifier)
                              .selectDimension(selectedDimension: "");
                        },
                        child: Chip(
                          side: BorderSide.none,
                          label: Text(sport),
                          backgroundColor:
                              selectedSportsIndex == index ? greenColor : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Select Dimension for $selectedSports: ",
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),

              //*show field according to selected Sports
              SizedBox(
                  height: 400,
                  child: DimensionsListView(
                      turf: widget.turf, selectedSports: selectedSports)),
              const SizedBox(height: 10),

              //** give review if not given */
              ref.watch(getTwoBookingsProvider(widget.turf.turfId)).when(
                    data: (data) {
                      if (!user.hasGivenReview && data.length >= 2) {
                        return GiveReviewCard(turfId: widget.turf.turfId);
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                    error: (error, stackTrace) => Center(
                      child: Text(error.toString()),
                    ),
                    loading: () => const Center(
                      child: SizedBox(
                          width: 50,
                          height: 100,
                          child: CircularProgressIndicator()),
                    ),
                  ),

              //** cutomer reviews */
              const Text(
                "Customer Reviews:",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: [
                    Text(
                      getAverageRating().toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingBarIndicator(
                          rating: double.parse(
                              getAverageRating().toStringAsFixed(2)),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return const Icon(
                              Icons.star,
                              color: Colors.amber,
                            );
                          },
                        ),
                        Text(
                          "Based On $formattedLength Reviews",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(height: 20),
              ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.turf.ratings.length,
                itemBuilder: (context, index) {
                  final Rating singleRating = widget.turf.ratings[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Add this line
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(singleRating.profile),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      singleRating.username,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    RatingBarIndicator(
                                      itemSize: 17,
                                      rating: singleRating.rating.toDouble(),
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        return const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: 300,
                                      child: Text(
                                        singleRating.comment,
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const Divider(),
                            // ...
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: selectedDimension != ""
          ? FloatingActionButton.extended(
              onPressed: () {
                context.pushNamed(AppRoutes.timeSelection.name,
                    extra: widget.turf,
                    pathParameters: {
                      "name": widget.turfName,
                    });
              },
              label: const Text('Continue'),
              icon: const Icon(
                Icons.done,
                color: Colors.white,
              ),
              backgroundColor: greenColor,
            )
          : FloatingActionButton.extended(
              onPressed: () {
                showSnackbar(
                    context: context, text: "Please Select a Dimension");
              },
              label: Text(
                'Continue',
                style: TextStyle(
                    color: Colors.grey[300],
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
              backgroundColor: Colors.grey,
            ),
    );
  }
}
