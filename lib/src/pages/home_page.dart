import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import '../../widgets/demo/test_socket.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // child: SocketPage(),
      child: Text(AppLocalizations.of(context)!.language),
    );
  }
}
