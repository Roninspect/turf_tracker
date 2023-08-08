import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_tracker/features/auth/pages/forgot_password.dart';
import 'package:turf_tracker/features/auth/pages/select_district_page.dart';
import 'package:turf_tracker/features/bookings/pages/booking_details_page.dart';
import 'package:turf_tracker/features/profile/pages/edit_profile.dart';
import 'package:turf_tracker/features/teams/pages/add_mod_page.dart';
import 'package:turf_tracker/features/teams/pages/create_team_page.dart';
import 'package:turf_tracker/features/teams/pages/edit_team_page.dart';
import 'package:turf_tracker/features/teams/pages/members_page.dart';
import 'package:turf_tracker/features/teams/pages/mod_tools.dart';
import 'package:turf_tracker/features/teams/pages/mods_list_page.dart';
import 'package:turf_tracker/features/teams/pages/remove_members.dart';
import 'package:turf_tracker/features/teams/pages/search_team_page.dart';
import 'package:turf_tracker/features/teams/pages/team_details_pgae.dart';
import 'package:turf_tracker/features/turfs/pages/payment_confirm_page.dart';
import 'package:turf_tracker/features/turfs/pages/time_selection_page.dart';
import 'package:turf_tracker/features/turfs/pages/turf_details_page.dart';
import 'package:turf_tracker/models/booking.dart';
import 'package:turf_tracker/models/team.dart';
import 'package:turf_tracker/models/turf.dart';
import 'package:turf_tracker/models/user.dart';

import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/register_page.dart';
import '../features/auth/repository/auth_repository.dart';
import '../features/root/pages/rootpage.dart';

enum AppRoutes {
  root,
  login,
  register,
  turfDetails,
  timeSelection,
  paymentConfirm,
  createTeam,
  teamDetails,
  members,
  mods,
  modTools,
  addMods,
  editTeam,
  searchTeam,
  removeMember,
  editProfile,
  verifyDistrict,
  forgotPassword,
  bookingDetails
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
          path: "/login",
          name: AppRoutes.login.name,
          builder: (context, state) => const LoginPage(),
          routes: [
            GoRoute(
              path: "register",
              name: AppRoutes.register.name,
              builder: (context, state) => const RegisterPage(),
            ),
            GoRoute(
              path: "forgotPassword",
              name: AppRoutes.forgotPassword.name,
              builder: (context, state) => const ForgotPassword(),
            ),
          ]),
      GoRoute(
        path: '/',
        name: AppRoutes.root.name,
        builder: (context, state) => const RootPage(),
        routes: [
          GoRoute(
            path: 'turf/:name',
            name: AppRoutes.turfDetails.name,
            builder: (context, state) {
              String name = state.pathParameters['name']!;
              Turf turf = state.extra as Turf;
              return TurfDetailsPage(turf: turf, turfName: name);
            },
            routes: [
              GoRoute(
                path: 'timeSelection',
                name: AppRoutes.timeSelection.name,
                builder: (context, state) {
                  final Turf turf = state.extra as Turf;
                  return TimeSelectionPage(turf: turf);
                },
              ),
              GoRoute(
                path: 'paymentConfirm',
                name: AppRoutes.paymentConfirm.name,
                builder: (context, state) {
                  final Turf turf = state.extra as Turf;
                  return PaymentConfirmPage(turf: turf);
                },
              )
            ],
          ),
          GoRoute(
            path: 'createTeam',
            name: AppRoutes.createTeam.name,
            builder: (context, state) => const CreateNewTurfPage(),
          ),
          GoRoute(
              path: 'team/:teamId',
              name: AppRoutes.teamDetails.name,
              builder: (context, state) {
                final String teamId = state.pathParameters['teamId']!;
                final Team team = state.extra as Team;
                return TeamDetailsPage(
                  teamId: teamId,
                  team: team,
                );
              },
              routes: [
                GoRoute(
                  path: 'members',
                  name: AppRoutes.members.name,
                  builder: (context, state) {
                    final Team team = state.extra as Team;
                    return MembersPage(team: team);
                  },
                ),
                GoRoute(
                  path: 'mods',
                  name: AppRoutes.mods.name,
                  builder: (context, state) {
                    final Team team = state.extra as Team;
                    return ModsPage(team: team);
                  },
                ),
                GoRoute(
                  path: 'modTools',
                  name: AppRoutes.modTools.name,
                  builder: (context, state) {
                    final Team team = state.extra as Team;
                    return ModToolsPage(team: team);
                  },
                ),
                GoRoute(
                  path: 'addMods',
                  name: AppRoutes.addMods.name,
                  builder: (context, state) {
                    final Team team = state.extra as Team;
                    return AddModPage(team: team);
                  },
                ),
                GoRoute(
                  path: 'editTeam',
                  name: AppRoutes.editTeam.name,
                  builder: (context, state) {
                    final Team team = state.extra as Team;
                    return EditTeamPage(team: team);
                  },
                ),
                GoRoute(
                  path: 'removeMember',
                  name: AppRoutes.removeMember.name,
                  builder: (context, state) {
                    final Team team = state.extra as Team;
                    return RemoveMemberPage(team: team);
                  },
                ),
              ]),
          GoRoute(
            path: 'searchTeam',
            name: AppRoutes.searchTeam.name,
            builder: (context, state) {
              return const SearchScreen();
            },
          ),
          GoRoute(
            path: 'editProfile',
            name: AppRoutes.editProfile.name,
            builder: (context, state) {
              final UserModel userModel = state.extra as UserModel;
              return EditProfilePage(user: userModel);
            },
          ),
          GoRoute(
            path: 'bookingDetails/:bookingId',
            name: AppRoutes.bookingDetails.name,
            builder: (context, state) {
              final Booking booking = state.extra as Booking;
              final String bookingId = state.pathParameters['bookingId']!;
              return BookingDetailsPage(
                bookingModel: booking,
                bookingId: bookingId,
              );
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) async {
      if (authState.isLoading || authState.hasError) return null;
      final isAuth = authState.valueOrNull != null;

      final isHome = state.location == '/';

      if (isHome) {
        return isAuth ? '/' : '/login';
      }

      final isLoggingIn = state.location == '/login';
      final isRegister = state.location == '/login/register';
      final isForgotPage = state.location == '/login/forgotPassword';

      if (isLoggingIn) return isAuth ? '/' : null;

      if (isRegister) {
        if (isAuth) {
          return '/';
        } else {
          return null;
        }
      }
      if (isForgotPage) {
        if (isAuth) {
          return '/';
        } else {
          return null;
        }
      }

      return isAuth ? null : '/';
    },
  );
});
