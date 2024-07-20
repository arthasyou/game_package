import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../utils/common_utils.dart';
import 'common/lable.dart';

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

// 转盘界面
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

class OddsComponent extends PositionComponent {
  final List<LabeledSpriteComponent> _odds = [];
  final int _numOdds = 8;
  final List<String> _oddsImagePaths = [
    'fruit_img_4.png',
    'fruit_img_9.png',
    'fruit_img_9.png',
    'fruit_img_9.png',
    'fruit_img_9.png',
    'fruit_img_9.png',
    'fruit_img_9.png',
    'fruit_img_4.png',
  ];

  final List<String> _oddsValues = [
    '100',
    '40',
    '30',
    '20',
    '20',
    '15',
    '10',
    '5',
  ];

  final Vector2 _oddsSize = Vector2(90, 50);

  OddsComponent() : super();

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < _numOdds; i++) {
      final sprite = await loadSprite(_oddsImagePaths[i]);
      final lable = (i == 0 || i == _numOdds - 1)
          ? LabeledSpriteComponent(
              sprite: sprite, labelText: _oddsValues[i], size: _oddsSize)
          : LabeledSpriteComponent(
              sprite: sprite,
              labelText: _oddsValues[i],
              size: _oddsSize,
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            );

      _odds.add(lable);
      add(lable);
    }
    linePosition(_odds, _oddsSize, size);
    position = Vector2(0, 376);
  }
}

class ActiveOddsComponent extends PositionComponent {
  final List<LabeledSpriteComponent> odds = [];
  final int _numOdds = 6;

  final List<String> _oddsValues = [
    '40',
    '30',
    '20',
    '20',
    '15',
    '10',
  ];

  final Vector2 _oddsSize = Vector2(90, 50);

  ActiveOddsComponent() : super();

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < _numOdds; i++) {
      final sprite = await loadSprite('fruit_img_10.png');
      final lable = LabeledSpriteComponent(
        sprite: sprite,
        labelText: _oddsValues[i],
        size: _oddsSize,
      )..isVisible = false;

      odds.add(lable);
      add(lable);
    }
    linePosition(odds, _oddsSize, size);
    position = Vector2(0, 376);
  }
}
