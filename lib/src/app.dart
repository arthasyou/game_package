import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:game_package/src/pages/game_page.dart';
import 'package:game_package/src/pages/home_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'provider/locale_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Locale? locale = ref.watch(localProvider).locale;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exchange',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      locale: locale,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      home: const GamePage(),
    );
  }
}
