import 'package:flame/components.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../provider/locale_provider.dart';

class LanguagePickerComponent extends PositionComponent {
  final WidgetRef ref;

  LanguagePickerComponent(this.ref);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final provider = ref.read(localProvider);
  }
}
