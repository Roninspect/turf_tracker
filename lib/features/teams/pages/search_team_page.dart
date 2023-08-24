import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_tracker/common/colors.dart';
import 'package:turf_tracker/models/team.dart';

import '../../../router/router.dart';
import '../providers/search_products_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  TextEditingController? queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final teams = ref.watch(searchedTeamNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              context.pop();
              ref.invalidate(searchedTeamNotifierProvider);
            },
            icon: const Icon(Icons.arrow_back)),
        flexibleSpace: Container(),
        title: TextFormField(
          controller: queryController,
          onChanged: (value) {
            if (value.isNotEmpty) {
              ref
                  .read(searchedTeamNotifierProvider.notifier)
                  .fetchTeamBySearch(context: context, searchQuery: value);
            }
          },
          decoration: InputDecoration(
            prefixIcon: InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.only(
                  left: 6,
                ),
                child: Icon(
                  Icons.search,
                  size: 23,
                  color: greenColor,
                ),
              ),
            ),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: greenColor)),
            contentPadding: const EdgeInsets.only(top: 10),
            hintText: "Search Team (in LowerCase)",
            hintStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          teams.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text("No Team Found"),
                  ),
                )
              : Expanded(
                  child: ListView.separated(
                    itemCount: teams.length,
                    itemBuilder: (context, index) {
                      final team = teams[index];
                      return GestureDetector(
                          onTap: () {
                            context.pushNamed(AppRoutes.teamDetails.name,
                                pathParameters: {
                                  "teamId": team.tid,
                                },
                                extra: team);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 200,
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.network(
                                      team.teamProfile,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  team.name,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Members ${team.members.length}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ),
        ],
      ),
    );
  }
}
