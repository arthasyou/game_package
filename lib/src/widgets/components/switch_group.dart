import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../provider/slot_machine_provider.dart';

import 'image_button.dart';
import 'image_lable.dart';

class SwitchWidget extends ConsumerWidget {
  const SwitchWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(slotMachineProvider);

    return Column(children: <Widget>[
      ImageButton(
        buttonText: AppLocalizations.of(context)!.change,
        imageSizeX: 60,
        imageSizeY: 25,
        containerSizeX: 60,
        containerSizeY: 25,
        onTap: () {
          provider.changeChip();
        },
        pressedImagePath:
            'packages/game_package/assets/images/fruit_btn_bet_99.png',
        normalImagePath:
            'packages/game_package/assets/images/fruit_btn_bet_9.png',
      ),
      ImageLable(
        imagePath: 'packages/game_package/assets/images/fruit_img_8.png',
        sizeX: 50,
        sizeY: 15,
        text: provider.chip.toString(),
      ),
    ]);
  }
}
