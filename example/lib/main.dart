import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:game_package/game_package.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
