import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/slot_machine_provider.dart';
import 'image_button.dart';

class ButtonGroup extends ConsumerWidget {
  const ButtonGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Define the paths for normal and pressed images
    final List<String> normalImagePaths = [
      'packages/game_package/assets/images/fruit_btn_bet_8.png',
      'packages/game_package/assets/images/fruit_btn_bet_7.png',
      'packages/game_package/assets/images/fruit_btn_bet_6.png',
      'packages/game_package/assets/images/fruit_btn_bet_5.png',
      'packages/game_package/assets/images/fruit_btn_bet_4.png',
      'packages/game_package/assets/images/fruit_btn_bet_3.png',
      'packages/game_package/assets/images/fruit_btn_bet_2.png',
      'packages/game_package/assets/images/fruit_btn_bet_1.png',
    ];

    final List<String> pressedImagePaths = [
      'packages/game_package/assets/images/fruit_btn_bet_88.png',
      'packages/game_package/assets/images/fruit_btn_bet_77.png',
      'packages/game_package/assets/images/fruit_btn_bet_66.png',
      'packages/game_package/assets/images/fruit_btn_bet_55.png',
      'packages/game_package/assets/images/fruit_btn_bet_44.png',
      'packages/game_package/assets/images/fruit_btn_bet_33.png',
      'packages/game_package/assets/images/fruit_btn_bet_22.png',
      'packages/game_package/assets/images/fruit_btn_bet_11.png',
    ];

    final List<double> offsets = [0, -12, -21, -27, -30, -36, -46, -60];

    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(8, (index) {
        // final x1 = -index * (12.0 - 1.5 * index);
        // final x2 = -index * (12.0 - 0.6 * (15 - index));

        return Transform.translate(
          offset: Offset(offsets[index], 0),
          child: ImageButton(
            imageSizeX: 56,
            imageSizeY: 50,
            onTap: () {
              ref.read(slotMachineProvider).increaseBet(index);
            },
            normalImagePath: normalImagePaths[index],
            pressedImagePath: pressedImagePaths[index],
          ),
        );
      }),
    );
  }
}
