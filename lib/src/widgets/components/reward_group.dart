import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../provider/slot_machine_provider.dart';

import 'image_lable.dart';

class RewardWidget extends ConsumerWidget {
  const RewardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(slotMachineProvider);

    return Stack(children: [
      Stack(
        children: [
          Image.asset(
            'packages/game_package/assets/images/fruit_light.png',
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
          Container(
            width: 200,
            height: 200,
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                ImageLable(
                  imagePath:
                      'packages/game_package/assets/images/fruit_img_2.png',
                  sizeX: 60,
                  sizeY: 60,
                  text: provider.bs.toString(),
                  textAlignment: Alignment.center,
                  fontSize: 30,
                ),
                const SizedBox(height: 100),
                ImageLable(
                  imagePath:
                      'packages/game_package/assets/images/fruit_img_2.png',
                  sizeX: 130,
                  sizeY: 30,
                  text: provider.win.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
