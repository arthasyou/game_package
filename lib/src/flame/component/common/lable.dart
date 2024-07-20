import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LabeledSpriteComponent extends PositionComponent with HasVisibility {
  final SpriteComponent spriteComponent;
  final TextComponent textComponent;
  String labelText;

  LabeledSpriteComponent({
    required Sprite sprite,
    required this.labelText,
    required Vector2 size,
    Vector2? position,
    TextStyle? textStyle,
    Anchor? anchor,
    Anchor? textAnchor,
    Vector2? textPosition,
    // 新增可选参数用于自定义文本样式
  })  : spriteComponent = SpriteComponent(sprite: sprite, size: size),
        textComponent = TextComponent(
          text: labelText,
          anchor: textAnchor ?? Anchor.center,
          position: textPosition ?? Vector2(0, 0),
          textRenderer: TextPaint(
            style: textStyle ??
                const TextStyle(
                  color: Colors.yellow, // 默认颜色
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        super(
          position: position ?? Vector2.zero(),
          anchor: anchor ?? Anchor.topLeft,
          size: size,
        ) {
    add(spriteComponent);
    add(textComponent);

    // 居中文本组件
    textComponent.position = Vector2(size.x / 2, size.y / 2);
    textComponent.anchor = Anchor.center;
  }
  set textStyle(TextStyle style) {
    textComponent.textRenderer = TextPaint(style: style);
  }

  void updateLabel(String newLabel) {
    textComponent.text = newLabel;
  }
}
