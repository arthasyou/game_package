import 'package:flame/game.dart';

import 'package:flutter/material.dart';
import 'package:game_package/src/errors/error_display.dart';
import 'package:game_package/src/provider/error_provider.dart';
import 'package:game_package/src/widgets/language_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../flame/slot_machine.dart';
import '../../protos/message.pb.dart';
import '../../provider/slot_machine_provider.dart';
import '../../services/message_service.dart';
import '../../services/web_socket_service.dart';
import '../components/bets.dart';
import '../components/big_or_small.dart';
import '../components/image_button.dart';
import '../components/image_button_group.dart';
import '../components/image_lable.dart';
import '../components/reward_group.dart';
import '../components/switch_group.dart';

class SlotMachineWidget extends ConsumerStatefulWidget {
  const SlotMachineWidget({super.key});

  @override
  SlotMachineWidgetState createState() => SlotMachineWidgetState();
}

class SlotMachineWidgetState extends ConsumerState<SlotMachineWidget> {
  late SlotMachine game;
  late MessageService _messageService;

  @override
  void initState() {
    super.initState();
    // 初始化游戏实例
    game = SlotMachine(ref.read(slotMachineProvider));
    _messageService = MessageService();
    ref
        .read(webSocketProvider)
        .addListener(() => _messageService.onMessageReceived(ref));
    _messageService.sendMessage(ref, 1001, UserInfoArg());
  }

  @override
  Widget build(BuildContext context) {
    // return const Text("abg");
    final provider = ref.watch(slotMachineProvider);

    // 使用 SchedulerBinding 来确保在当前帧完成后再处理 shouldStartSpinning
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.shouldStartSpinning) {
        provider.setShouldStartSpinning(false); // 重置状态
        provider.setIsSpinning(true);
        game.startSpinning();
      }
    });

    return Stack(
      children: [
        Center(
          child: GameWidget(game: game),
        ),
        // 国际化
        const Positioned(
          top: 70,
          left: 10,
          child: LanguagePickerWidget(),
        ),
        // 金币
        Positioned(
            top: 85,
            left: (MediaQuery.of(context).size.width + 80) / 2,
            child: ImageLable(
              imagePath: 'packages/game_package/assets/images/fruit_img_8.png',
              sizeX: 150,
              sizeY: 20,
              text: provider.coin.toString(),
            )),
        // 奖励
        Positioned(
          top: 190,
          left: (MediaQuery.of(context).size.width - 190) / 2,
          child: const RewardWidget(),
        ),
        // 开始按钮
        Positioned(
          top: 438,
          left: (MediaQuery.of(context).size.width / 2) + 134,
          child: ImageButton(
            buttonText: AppLocalizations.of(context)!.go,
            imageSizeX: 60,
            imageSizeY: 40,
            containerSizeX: 60,
            containerSizeY: 40,
            onTap: () {
              _messageService.sendMessage(
                  ref, 2001, FruitPlayArg(flag: '0', fruits: provider.bets));
            },
            pressedImagePath:
                'packages/game_package/assets/images/fruit_btn_bet_100.png',
            normalImagePath:
                'packages/game_package/assets/images/fruit_btn_bet_10.png',
            isEnabled: !provider.isSpinning,
          ),
        ),
        // 切换按钮
        Positioned(
          top: 438,
          left: (MediaQuery.of(context).size.width / 2) - 170,
          child: const SwitchWidget(),
        ),
        // 水果按钮
        Positioned(
          top: 566,
          left: ((MediaQuery.of(context).size.width - 388) / 2),
          child: const ButtonGroup(),
        ),
        // 赌大小按钮
        Positioned(
          top: 438,
          left: ((MediaQuery.of(context).size.width - 220) / 2),
          child: const BigSmallWidget(),
        ),
        // 水果压分
        Positioned(
          top: 520,
          left: ((MediaQuery.of(context).size.width - 374) / 2),
          child: const BetsWidget(),
        ),
        // 显示错误
        Positioned(
          top: 650,
          left: ((MediaQuery.of(context).size.width - 50) / 2),
          child: const ErrorDisplayWidget(),
        ),
        Positioned(
          top: 200,
          left: 0,
          right: 0,
          child: TextButton(
            onPressed: () {
              ref.read(errorProvider.notifier).showError("错误");
            },
            child: const Text("ttt"),
          ),
        ),
      ],
    );
  }
}
