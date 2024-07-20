import 'package:flame/components.dart';

// TODO 帮我做一个下拉的控件用来做国际化
class DropdownButtonComponent extends PositionComponent {
  final List<String> options;
  final Function(String) onSelected;
  String? selectedOption;
  bool isExpanded = false;

  DropdownButtonComponent({
    required this.options,
    required this.onSelected,
    this.selectedOption,
  });
}
