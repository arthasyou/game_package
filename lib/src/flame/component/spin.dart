import 'package:flame/components.dart';
import '../utils/common_utils.dart';

class LightComponent extends SpriteComponent with HasVisibility {
  final double pixel;

  LightComponent({
    required this.pixel,
  }) : super();

  @override
  Future<void> onLoad() async {
    sprite = await loadSprite('fruit_icon_light.png');
    size = Vector2(pixel, pixel);
    anchor = Anchor.center;
  }
}

class SpinComponent extends PositionComponent {
  List<LightComponent> lights = [];
  final int numSpin;
  final double _size = 88.57;

  SpinComponent({
    required this.numSpin,
  }) : super();

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < numSpin; i++) {
      final light = LightComponent(pixel: _size)..isVisible = false;

      lights.add(light);
      add(light);
    }

    _positionSprites();
  }

  // 设置精灵和框架的位置
  void _positionSprites() {
    final int side = numSpin ~/ 4;

    for (int i = 0; i < numSpin; i++) {
      double x, y;
      if (i < side) {
        x = _size * i;
        y = 0;
      } else if (i < 2 * side) {
        x = _size * side;
        y = _size * (i - side);
      } else if (i < 3 * side) {
        x = _size * (3 * side - i);
        y = _size * side;
      } else {
        x = 0;
        y = _size * (4 * side - i);
      }

      // 将所有精灵和框架的中心对齐到游戏区域的中心
      lights[i].position = Vector2(x - 266, y - 327);
    }
  }
}
