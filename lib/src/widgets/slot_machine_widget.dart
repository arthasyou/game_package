import 'package:flame/camera.dart';
import 'package:flame/game.dart';

import 'package:flutter/material.dart';
import 'package:game_package/src/errors/error_display.dart';
import 'package:game_package/src/flame/game_word.dart';
import 'package:game_package/src/provider/error_provider.dart';
import 'package:game_package/src/widgets/language_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../protos/message.pb.dart';
import '../provider/slot_machine_provider.dart';
import '../services/message_service.dart';
import '../services/web_socket_service.dart';
import 'components/bets.dart';
import 'components/big_or_small.dart';
import 'components/image_button.dart';
import 'components/image_button_group.dart';
import 'components/image_lable.dart';
import 'components/reward_group.dart';
import 'components/switch_group.dart';

class SlotMachineWidget extends ConsumerStatefulWidget {
  const SlotMachineWidget({super.key});

  @override
  SlotMachineWidgetState createState() => SlotMachineWidgetState();
}

class SlotMachineWidgetState extends ConsumerState<SlotMachineWidget> {
  late FlameGame game;
  late MessageService _messageService;
  late GameWorld world;

  @override
  void initState() {
    super.initState();
    // 初始化游戏实例

    _messageService = MessageService();

    ref
        .read(webSocketProvider)
        .addListener(() => _messageService.onMessageReceived(ref));

    // _messageService.sendMessage(ref, 1001, UserInfoArg());
  }

  @override
  Widget build(BuildContext context) {
    // return const Text("abg");
    world = GameWorld(
      ref: ref,
      messageService: _messageService,
      localizedStringSpin: AppLocalizations.of(context)!.go,
      localizedStringSwitch: AppLocalizations.of(context)!.change,
    );

    game = FlameGame(
      world: world,
      camera: CameraComponent.withFixedResolution(width: 750, height: 1334),
    );

    return Consumer(builder: (context, ref, child) {
      final provider = ref.watch(slotMachineProvider);

      // 使用 SchedulerBinding 来确保在当前帧完成后再处理 shouldStartSpinning
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (provider.shouldStartSpinning) {
          provider.setShouldStartSpinning(false); // 重置状态
          // provider.setIsSpinning(true);
          world.startSpinning();
        }
        if (provider.shouldStartBOS) {
          provider.setShouldStartSpinning(false); // 重置状态
          // provider.setIsSpinning(true);
          world.startBOS();
        }
        if (provider.shouldUpdateCoin) {
          provider.setShouldUpdateCoin(false);
          world.updateCoin();
        }
      });
      return Stack(
        children: [
          Center(
            child: GameWidget(game: game),
          ),
          // 国际化
          const Positioned(
            top: 30,
            left: 10,
            child: LanguagePickerWidget(),
          ),
        ],
      );
    });
  }
}
