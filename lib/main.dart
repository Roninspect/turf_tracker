import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_version_plus/new_version_plus.dart';

import 'package:turf_tracker/router/router.dart';

import 'common/colors.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  String? release;
  @override
  void initState() {
    super.initState();
    final newVersion = NewVersionPlus(
      iOSId: 'com.disney.disneyplus',
      androidId: 'com.whatsapp',
      androidPlayStoreCountry: "es_ES",
      androidHtmlReleaseNotes: true,
    );

    // if (simpleBehavior) {
    basicStatusCheck(newVersion);
    // }
    // else {
    // advancedStatusCheck(newVersion);
    // } //support country code
  }

  basicStatusCheck(NewVersionPlus newVersion) async {
    final version = await newVersion.getVersionStatus();
    if (version != null) {
      release = version.releaseNotes ?? "";

      setState(() {});
    }
    newVersion.showAlertIfNecessary(
      context: context,
      launchModeVersion: LaunchModeVersion.external,
    );
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey[850],
        ),
        appBarTheme: const AppBarTheme(backgroundColor: backgroundColor),
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: GoogleFonts.roboto(fontWeight: FontWeight.bold).fontFamily,
      ),
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
    );
  }
}
