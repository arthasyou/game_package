import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_package/src/flame/component/common/lable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../protos/message.pb.dart';
import '../../provider/slot_machine_provider.dart';
import '../../services/message_service.dart';
import '../utils/common_utils.dart';
import 'common/image_button.dart';
import 'game_display.dart';

class SpinButtonComponent extends PositionComponent {
  late ImageButtonComponent _spinButton;
  final void Function()? onTap;
  final String localizedString;

  SpinButtonComponent({
    required this.onTap,
    required this.localizedString,
  });
  @override
  Future<void> onLoad() async {
    _spinButton = ImageButtonComponent(
      buttonImagePath: 'fruit_btn_bet_10.png',
      buttonDownImagePath: 'fruit_btn_bet_100.png',
      imageSize: Vector2(100, 80),
      imagePosition: Vector2(0, 0),
      imageText: localizedString,
      textPosition: Vector2(0, -22),
      textWeight: FontWeight.bold,
      textSize: 28,
      onTap: onTap,
      // isEnabled: false,
    );
    position = Vector2(290, 315);
    add(_spinButton);
  }

  void setEnabled(bool isEnabled) {
    _spinButton.setEnabled(isEnabled);
  }
}

class FruitButtonGroup extends PositionComponent {
  final List<ImageButtonComponent> buttons = [];

  final List<String> normalImagePaths = [
    'fruit_btn_bet_8.png',
    'fruit_btn_bet_7.png',
    'fruit_btn_bet_6.png',
    'fruit_btn_bet_5.png',
    'fruit_btn_bet_4.png',
    'fruit_btn_bet_3.png',
    'fruit_btn_bet_2.png',
    'fruit_btn_bet_1.png',
  ];

  final List<String> pressedImagePaths = [
    'fruit_btn_bet_88.png',
    'fruit_btn_bet_77.png',
    'fruit_btn_bet_66.png',
    'fruit_btn_bet_55.png',
    'fruit_btn_bet_44.png',
    'fruit_btn_bet_33.png',
    'fruit_btn_bet_22.png',
    'fruit_btn_bet_11.png',
  ];

  final List<double> offSets = [-321, -238, -148, -51, 51, 148, 238, 321];

  final WidgetRef ref;
  final BetsComponent bets;
  final CoinComponent coin;
  FruitButtonGroup({
    required this.ref,
    required this.bets,
    required this.coin,
  }) : super();
  @override
  Future<void> onLoad() async {
    for (int i = 0; i < normalImagePaths.length; i++) {
      final btn = ImageButtonComponent(
        buttonImagePath: normalImagePaths[i],
        buttonDownImagePath: pressedImagePaths[i],
        imageSize: Vector2(110, 110),
        imagePosition: Vector2(offSets[i], 0),
        onTap: () {
          ref.read(slotMachineProvider).increaseBet(i);
          final v = ref.read(slotMachineProvider).getBet(i);
          bets.updateLabel(i, v.toString());
          coin.updateLabel();
        },
      );
      buttons.add(btn);
      add(btn);
    }

    position = Vector2(0, 595);
  }

  void setEnabled(bool isEnabled) {
    for (int i = 0; i < buttons.length; i++) {
      buttons[i].setEnabled(isEnabled);
    }
  }
}

class BigOrSmallComponent extends PositionComponent {
  final List<ImageButtonComponent> _bsBtn = [];
  late ImageButtonComponent _betButton;
  late LabeledSpriteComponent _label;
  final WidgetRef ref;
  final CoinComponent coin;

  final List<String> _btnText = ['2-6', '8-12'];
  final MessageService messageService;

  BigOrSmallComponent({
    required this.ref,
    required this.coin,
    required this.messageService,
  });
  @override
  Future<void> onLoad() async {
    final provider = ref.read(slotMachineProvider);
    for (int i = 0; i < _btnText.length; i++) {
      final btn = ImageButtonComponent(
        buttonImagePath: 'fruit_btn_bet_111.png',
        buttonDownImagePath: 'fruit_btn_bet_112.png',
        imageSize: Vector2(100, 80),
        imagePosition: Vector2(0, 0),
        imageText: _btnText[i],
        textPosition: Vector2(0, -10),
        textWeight: FontWeight.bold,
        textSize: 26,
        onTap: () {
          messageService.sendMessage(
              ref, 2002, BsPlayArg(index: i, amount: provider.bigOrSmallBet));
        },
      );
      _bsBtn.add(btn);
      btn.position = Vector2(100 * (i + 1).toDouble() - 100, 0);
      add(btn);
    }

    _betButton = ImageButtonComponent(
      buttonImagePath: 'fruit_btn_bet_111.png',
      buttonDownImagePath: 'fruit_btn_bet_112.png',
      imageSize: Vector2(100, 80),
      imagePosition: Vector2(0, 0),
      imageText: 'Bet',
      textPosition: Vector2(0, -10),
      textWeight: FontWeight.bold,
      textSize: 30,
      onTap: () {
        provider.addBoSBet();
        _label.updateLabel(provider.bigOrSmallBet.toString());
        coin.updateLabel();
      },
    );
    add(_betButton);
    _betButton.position = Vector2(200, 0);

    final sprite = await loadSprite('fruit_img_8.png');
    _label = LabeledSpriteComponent(
      labelText: provider.bigOrSmallBet.toString(),
      sprite: sprite,
      size: Vector2(150, 40),
      position: Vector2(-50, 20),
    );
    add(_label);
    _label.position = Vector2(260, -20);

    position = Vector2(-190, 315);
  }

  void setEnabled(bool isEnabled) {
    for (int i = 0; i < _bsBtn.length; i++) {
      _bsBtn[i].setEnabled(isEnabled);
    }
    _betButton.setEnabled(isEnabled);
  }
}

class SwitchButtonComponent extends PositionComponent {
  late ImageButtonComponent _spinButton;
  late LabeledSpriteComponent _label;
  final WidgetRef ref;
  final String localizedString;

  SwitchButtonComponent({
    required this.ref,
    required this.localizedString,
  });
  @override
  Future<void> onLoad() async {
    final provider = ref.read(slotMachineProvider);
    _spinButton = ImageButtonComponent(
      buttonImagePath: 'fruit_btn_bet_9.png',
      buttonDownImagePath: 'fruit_btn_bet_99.png',
      imageSize: Vector2(100, 60),
      imagePosition: Vector2(0, 0),
      imageText: localizedString,
      textPosition: Vector2(0, -10),
      textWeight: FontWeight.bold,
      textSize: 20,
      onTap: () {
        provider.changeChip();
        _label.updateLabel(provider.chip.toString());
      },
    );
    add(_spinButton);

    final sprite = await loadSprite('fruit_img_8.png');
    _label = LabeledSpriteComponent(
      labelText: provider.chip.toString(),
      sprite: sprite,
      size: Vector2(90, 40),
      position: Vector2(-50, 20),
    );
    add(_label);

    position = Vector2(-290, 300);
  }

  // void setEnabled(bool isEnabled) {
  //   for (int i = 0; i < _spinButton.length; i++) {
  //     _spinButton[i].setEnabled(isEnabled);
  //   }
  // }
}
