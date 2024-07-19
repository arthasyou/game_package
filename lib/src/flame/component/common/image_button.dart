import 'package:flame/components.dart';

import '../../utils/common_utils.dart';

class BBBComponent extends SpriteComponent {
  BBBComponent() : super();

  @override
  Future<void> onLoad() async {
    sprite = await loadSprite('fruit_btn_bet_10.png');
    size = Vector2(100, 100);
    anchor = Anchor.center;
    position = Vector2(0, 0);
  }
}

class AAAComponent extends SpriteComponent {
  AAAComponent() : super();

  @override
  Future<void> onLoad() async {
    sprite = await loadSprite('fruit_btn_bet_100.png');
    size = Vector2(100, 100);
    anchor = Anchor.center;
    position = Vector2(0, 0);
  }
}
