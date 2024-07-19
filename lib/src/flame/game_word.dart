import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'component/background.dart';
import 'component/common/image_button.dart';
import 'component/spin.dart';
// import 'utils/common_utils.dart';

class GameWorld extends World with HasCollisionDetection {
  late Timer _timer; // 定时器
  int _highlightedIndex = 10; // 当前高亮的精灵索引
  // int _targetIndex = 0; // 目标高亮的精灵索引

  late BackgroundComponent _background;
  late FruitsComponent _fruts;
  late SpinComponent _spin;
  final int _numOfSpin = 24;

  late ButtonComponent _spinButton;

  @override
  Future<void> onLoad() async {
    // camera =
    //     CameraComponent.withFixedResolution(width: 750, height: 1334); // 设置相机
    // 背景
    _background = BackgroundComponent();
    await add(_background);

    // 水果
    _fruts = FruitsComponent();
    await add(_fruts);

    //转盘
    _spin = SpinComponent(numSpin: _numOfSpin);
    await add(_spin);

    //时间
    _timer = Timer(0.1, repeat: true, onTick: _rotateSprites);
    _timer.stop();
    _highlightSprite(_highlightedIndex);

    // 添加按钮
    _spinButton = ButtonComponent(
      button: BBBComponent(),
      buttonDown: AAAComponent(),
      onPressed: _onSpinButtonPressed,
      position: Vector2(100, 100),
      size: Vector2(100, 50),
    );
    await add(_spinButton);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_timer.isRunning()) {
      _timer.update(dt);
    }
  }

  // 旋转精灵
  void _rotateSprites() {
    _highlightedIndex = (_highlightedIndex + 1) % _numOfSpin;
    _highlightSprite(_highlightedIndex);
    // _highlightContinued(_highlightedIndex);
    // _oddsIndex = (_oddsIndex - 1) % 3;
    // _hightightOdds(_oddsIndex);
  }

  // 高亮指定索引的精灵
  void _highlightSprite(int index) {
    for (int i = 0; i < _numOfSpin; i++) {
      if (index == i) {
        _spin.lights[i].isVisible = true;
      } else {
        _spin.lights[i].isVisible = false;
      }
    }
  }

  // void startSpinning() async {}

  void startSpinning() async {
    _timer.start();
  }

  void _onSpinButtonPressed() {
    startSpinning();
  }
}
