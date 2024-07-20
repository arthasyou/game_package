import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../../utils/common_utils.dart';

class ImageButtonComponent extends PositionComponent {
  final String buttonImagePath;
  final String buttonDownImagePath;
  final Vector2 imageSize;
  final Vector2 imagePosition;
  final String? imageText;
  final Vector2? textPosition;
  final Color? textColor;
  final FontWeight? textWeight;
  final double? textSize;
  final void Function()? onTap;
  bool isEnabled;
  //
  late ButtonComponent button;

  ImageButtonComponent({
    required this.buttonImagePath,
    required this.buttonDownImagePath,
    required this.imageSize,
    required this.imagePosition,
    this.imageText,
    this.textPosition,
    this.textColor = Colors.white,
    this.textWeight = FontWeight.normal,
    this.textSize = 24,
    required this.onTap,
    this.isEnabled = true, // 默认情况下，按钮是启用的
  });

  late SpriteComponent _buttonSprite;
  late SpriteComponent _buttonDownSprite;

  @override
  Future<void> onLoad() async {
    _buttonSprite = SpriteComponent()
      ..sprite = await loadSprite(buttonImagePath)
      ..size = imageSize;
    _buttonDownSprite = SpriteComponent()
      ..sprite = await loadSprite(buttonDownImagePath)
      ..size = imageSize;

    button = ButtonComponent(
      button: _buttonSprite,
      buttonDown: isEnabled ? _buttonDownSprite : null,
      onReleased: isEnabled ? onTap : null, // 根据 isEnabled 控制 onTap
      position: imagePosition,
      anchor: Anchor.center,
      size: imageSize,
    );

    add(button);

    if (imageText != null) {
      // 添加文本
      final text = TextComponent(
        anchor: Anchor.center,
        position: textPosition,
        size: imageSize,
        text: imageText,
        textRenderer: TextPaint(
          style: TextStyle(
            color: isEnabled ? textColor : Colors.grey, // 如果禁用，文本颜色变灰
            fontSize: textSize,
            fontWeight: textWeight,
          ),
        ),
      );

      add(text);
    }
  }

  void setEnabled(bool enabled) {
    isEnabled = enabled;
    // 更新按钮的 onPressed 和外观
    button.onReleased = isEnabled ? onTap : null;
    button.buttonDown = isEnabled ? _buttonDownSprite : null;

    // 更新文本颜色
    if (children.isNotEmpty && children.last is TextComponent) {
      final textComponent = children.last as TextComponent;
      textComponent.textRenderer = TextPaint(
        style: TextStyle(
          color: isEnabled ? textColor : Colors.grey, // 如果禁用，文本颜色变灰
          fontSize: textSize,
          fontWeight: textWeight,
        ),
      );
    }
  }
}
