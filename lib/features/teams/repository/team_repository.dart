import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:turf_tracker/common/failure.dart';
import 'package:turf_tracker/common/typedefs.dart';
import 'package:turf_tracker/models/icon.dart';
import 'package:turf_tracker/models/team.dart';
import 'package:turf_tracker/models/user.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepository(
    firestore: FirebaseFirestore.instance,
  );
});

class TeamRepository {
  final FirebaseFirestore _firestore;

  TeamRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  //**  getUserTeams */

  Stream<List<Team>> getUserTeams({required String uid}) {
    return _firestore
        .collection("teams")
        .where("members", arrayContains: uid)
        .snapshots()
        .map((event) => event.docs.map((e) => Team.fromMap(e.data())).toList());
  }

//** getuserByUid to get members info */
  Stream<UserModel> getuserByUid({required String uid}) {
    return _firestore.collection("users").doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  //** Creating a new Team */

  FutureVoid createTeam({required Team teamModel}) async {
    try {
      return right(await _firestore
          .collection("teams")
          .doc(teamModel.tid)
          .set(teamModel.toMap()));
    } catch (e, stk) {
      print(stk);
      return left(Failure(stk.toString()));
    }
  }

  //** ypdating a team */

  FutureVoid updateTeam({required Team teamModel}) async {
    try {
      return right(await _firestore
          .collection("teams")
          .doc(teamModel.tid)
          .update(teamModel.toMap()));
    } catch (e, stk) {
      print(stk);
      return left(Failure(stk.toString()));
    }
  }

  FutureVoid addMod({required String teamid, required List mods}) async {
    try {
      return right(await _firestore
          .collection("teams")
          .doc(teamid)
          .update({"mods": mods}));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<IconModel>> getsportsIcons() {
    return _firestore.collection("sports_icons").snapshots().map(
        (event) => event.docs.map((e) => IconModel.fromMap(e.data())).toList());
  }

  //**  searching team */
  Future<List<Team>> searchTeam(String query) async {
    try {
      final snapshot = await _firestore
          .collection("teams")
          .where('nameInLowerCase',
              isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
              isLessThan: query.toLowerCase().isEmpty
                  ? null
                  : query.substring(0, query.length - 1) +
                      String.fromCharCode(
                          query.codeUnitAt(query.length - 1) + 1))
          .get();

      // Process the snapshot data and return the list of teams.
      List<Team> teamResult = [];
      for (var team in snapshot.docs) {
        teamResult.add(Team.fromMap(team.data()));
      }
      return teamResult;
    } catch (error) {
      // Handle the error here.
      print("Error searching teams: $error");
      return []; // Return an empty list in case of an error.
    }
  }

  //** joining a team */
  FutureVoid addMember({required String teamId, required String userId}) async {
    try {
      return right(await _firestore.collection("teams").doc(teamId).update({
        'members': FieldValue.arrayUnion([userId])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //* leaving a team */
  FutureVoid leaveMember(
      {required String teamId, required String userId}) async {
    try {
      return right(await _firestore.collection("teams").doc(teamId).update({
        'members': FieldValue.arrayRemove([userId])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<dynamic>> streamMembersFromFirestore(String teamId) {
    return FirebaseFirestore.instance
        .collection('teams')
        .doc(teamId)
        .snapshots()
        .map((event) => event.data()!['members']);
  }
}
