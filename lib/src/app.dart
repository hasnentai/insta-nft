import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart';
import 'package:insta_nft/src/instagram_login_view/instagram_login.dart';
import 'package:insta_nft/src/landing/landing.dart';
import 'package:insta_nft/src/landing/transactions.dart';
import 'package:insta_nft/src/mint_form/mint_form_view.dart';
import 'package:insta_nft/src/provider/wallet_provider.dart';
import 'package:insta_nft/src/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sample_feature/sample_item_details_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'package:provider/provider.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isTokenPresent = false;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> getToken() async {
    final SharedPreferences prefs = await _prefs;
    String? token = prefs.getString('token');
    setState(() {
      isTokenPresent = token != null ? token.isNotEmpty : false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WalletProvider())],
      child: AnimatedBuilder(
        animation: widget.settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',

            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],

            // Use AppLocalizations to configure the correct application title
            // depending on the user's locale.
            //
            // The appTitle is defined in .arb files found in the localization
            // directory.
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,

            // Define a light and dark color theme. Then, read the user's
            // preferred ThemeMode (light, dark, or system default) from the
            // SettingsController to display the correct theme.
            theme: darkTheme,

            themeMode: widget.settingsController.themeMode,

            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case SettingsView.routeName:
                      return SettingsView(
                          controller: widget.settingsController);
                    case SampleItemDetailsView.routeName:
                      return const SampleItemDetailsView();
                    case InstagramView.routeName:
                      return const InstagramView();
                    default:
                      return const InstagramView();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
