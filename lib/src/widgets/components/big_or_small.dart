import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../protos/message.pb.dart';
import '../../provider/slot_machine_provider.dart';
import '../../services/message_service.dart';
import 'image_button.dart';
import 'image_lable.dart';

class BigSmallWidget extends ConsumerWidget {
  const BigSmallWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(slotMachineProvider);
    final MessageService messageService = MessageService();

    return Row(children: <Widget>[
      ImageButton(
        buttonText: '2-6',
        imageSizeX: 50,
        imageSizeY: 40,
        containerSizeX: 50,
        containerSizeY: 40,
        normalImagePath:
            'packages/game_package/assets/images/fruit_btn_bet_112.png',
        pressedImagePath:
            'packages/game_package/assets/images/fruit_btn_bet_111.png',
        onTap: () {
          messageService.sendMessage(
              ref, 2002, BsPlayArg(index: 0, amount: provider.bigOrSmallBet));
        },
        isEnabled: !provider.isSpinning,
      ),
      const SizedBox(width: 2),
      ImageButton(
        buttonText: '8-12',
        imageSizeX: 50,
        imageSizeY: 40,
        containerSizeX: 50,
        containerSizeY: 40,
        normalImagePath:
            'packages/game_package/assets/images/fruit_btn_bet_112.png',
        pressedImagePath:
            'packages/game_package/assets/images/fruit_btn_bet_111.png',
        onTap: () {
          messageService.sendMessage(
              ref, 2002, BsPlayArg(index: 1, amount: provider.bigOrSmallBet));
        },
        isEnabled: !provider.isSpinning,
      ),
      const SizedBox(width: 2),
      ImageButton(
        buttonText: 'bet',
        imageSizeX: 50,
        imageSizeY: 40,
        containerSizeX: 50,
        containerSizeY: 40,
        normalImagePath:
            'packages/game_package/assets/images/fruit_btn_bet_112.png',
        pressedImagePath:
            'packages/game_package/assets/images/fruit_btn_bet_111.png',
        onTap: () {
          ref.read(slotMachineProvider).addBoSBet();
        },
        isEnabled: !provider.isSpinning,
      ),
      const SizedBox(width: 2),
      ImageLable(
        imagePath: 'packages/game_package/assets/images/fruit_img_8.png',
        sizeX: 80,
        sizeY: 20,
        text: provider.bigOrSmallBet.toString(),
      ),
    ]);
  }
}
