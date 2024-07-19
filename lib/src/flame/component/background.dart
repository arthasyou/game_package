import 'package:flame/components.dart';
import '../utils/common_utils.dart';

class BackgroundComponent extends SpriteComponent {
  BackgroundComponent() : super();

  @override
  Future<void> onLoad() async {
    sprite = await loadSprite('fruit_bg.png');
    size = Vector2(750, 1334);
    anchor = Anchor.center;
    position = Vector2(0, 0);
  }
}

class FruitsComponent extends SpriteComponent {
  FruitsComponent() : super();

  @override
  Future<void> onLoad() async {
    sprite = await loadSprite('fruit_bg_2.png');
    size = Vector2(620, 620);
    anchor = Anchor.center;
    position = Vector2(0, 0 - 62);
  }
}
