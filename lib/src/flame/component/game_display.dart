import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_package/src/provider/slot_machine_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../utils/common_utils.dart';
import 'common/lable.dart';

class BetsComponent extends PositionComponent {
  final List<LabeledSpriteComponent> lables = [];
  final int _num = 8;
  final Vector2 _oddsSize = Vector2(90, 45);
  final WidgetRef ref;

  BetsComponent({
    required this.ref,
  }) : super();

  @override
  Future<void> onLoad() async {
    final provider = ref.read(slotMachineProvider);
    for (int i = 0; i < _num; i++) {
      final sprite = await loadSprite('fruit_img_8.png');
      final lable = LabeledSpriteComponent(
        sprite: sprite,
        labelText: provider.bets[i].amount.toString(),
        size: _oddsSize,
      );

      lables.add(lable);
      add(lable);
    }
    linePosition(lables, _oddsSize, size);
    position = Vector2(0, 426);
  }

  void updateLabel(int index, String v) {
    lables[index].updateLabel(v);
  }
}

class CoinComponent extends PositionComponent {
  late LabeledSpriteComponent _label;
  final Vector2 _oddsSize = Vector2(250, 45);
  final WidgetRef ref;

  CoinComponent({
    required this.ref,
  }) : super();

  @override
  Future<void> onLoad() async {
    final provider = ref.read(slotMachineProvider);

    final sprite = await loadSprite('fruit_img_8.png');
    _label = LabeledSpriteComponent(
      sprite: sprite,
      labelText: provider.coin.toString(),
      size: _oddsSize,
    );

    add(_label);

    position = Vector2(100, -487);
  }

  void updateLabel() {
    final v = ref.read(slotMachineProvider).coin;
    _label.updateLabel(v.toString());
  }
}

class RewardComponent extends PositionComponent {
  late SpriteComponent _bg;
  late LabeledSpriteComponent _bos;
  late LabeledSpriteComponent _jp;

  final WidgetRef ref;

  RewardComponent({
    required this.ref,
  }) : super();

  @override
  Future<void> onLoad() async {
    final provider = ref.read(slotMachineProvider);

    _bg = SpriteComponent()
      ..sprite = await loadSprite('fruit_light.png')
      ..size = Vector2(400, 400)
      ..position = Vector2(0, 0)
      ..anchor = Anchor.center;

    add(_bg);

    final sprite = await loadSprite('fruit_img_2.png');
    _bos = LabeledSpriteComponent(
      sprite: sprite,
      labelText: provider.bs.toString(),
      size: Vector2(120, 120),
      anchor: Anchor.center,
      textStyle: const TextStyle(
        color: Colors.red, // 默认颜色
        fontSize: 50,
        fontWeight: FontWeight.bold,
      ),
      position: Vector2(0, -100),
    );

    add(_bos);

    final sprite1 = await loadSprite('fruit_icon_JP.png');
    _jp = LabeledSpriteComponent(
      sprite: sprite1,
      labelText: provider.win.toString(),
      size: Vector2(250, 50),
      anchor: Anchor.center,
      position: Vector2(0, 170),
      // textAnchor: Anchor.centerLeft,
      // textPosition: Vector2(100, 0),
    );

    add(_jp);

    position = Vector2(0, -70);
  }

  void updateLabel() {
    final win = ref.read(slotMachineProvider).win;
    _jp.updateLabel(win.toString());

    final bs = ref.read(slotMachineProvider).bs;
    _bos.updateLabel(bs.toString());
  }
}
