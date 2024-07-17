import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';

class ErrorState {
  final bool hasError;
  final String errorMessage;

  ErrorState({required this.hasError, required this.errorMessage});
}

class ErrorNotifier extends StateNotifier<ErrorState> {
  ErrorNotifier() : super(ErrorState(hasError: false, errorMessage: ''));

  void showError(String message) {
    state = ErrorState(hasError: true, errorMessage: message);
    Timer(const Duration(seconds: 2), () {
      state = ErrorState(hasError: false, errorMessage: '');
    });
  }
}

final errorProvider = StateNotifierProvider<ErrorNotifier, ErrorState>((ref) {
  return ErrorNotifier();
});
