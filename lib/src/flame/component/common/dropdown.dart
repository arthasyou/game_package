import 'package:flame/components.dart';

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
