import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../provider/error_provider.dart';

class ErrorDisplayWidget extends ConsumerWidget {
  const ErrorDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorState = ref.watch(errorProvider);

    return Visibility(
      visible: errorState.hasError,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          errorState.errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 30),
        ),
      ),
    );
  }
}
