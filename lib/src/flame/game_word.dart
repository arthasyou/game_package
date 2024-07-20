import 'package:flame/components.dart';
import 'package:game_package/src/provider/slot_machine_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../protos/message.pb.dart';
import '../services/message_service.dart';
import 'component/background.dart';
import 'component/game_controll.dart';
import 'component/game_display.dart';
import 'component/spin.dart';
// import 'utils/common_utils.dart';

class GameWorld extends World with HasCollisionDetection {
  GameWorld({
    required this.messageService,
    required this.ref,
    required this.localizedStringSpin,
    required this.localizedStringSwitch,
  });

  late Timer _timer; // 定时器
  final MessageService messageService; // 网络发送消息用
  final WidgetRef ref; // hook_provie相关
  final String localizedStringSpin;
  final String localizedStringSwitch;

  int _highlightedIndex = 10; // 当前高亮的精灵索引
  int _targetIndex = 0; // 目标高亮的精灵索引

  late BackgroundComponent _background;
  late FruitsComponent _frurts;
  late SpinComponent _spin;
  final int _numOfSpin = 24;

  late SpinButtonComponent _spinButton;
  late OddsComponent _odds;
  late ActiveOddsComponent _activedOdds;

  int _oddsIndex = 1;

  late BetsComponent _bets;

  late FruitButtonGroup _fruitBtns;
  late SwitchButtonComponent _switchBtn;
  late BigOrSmallComponent _bos;
  late CoinComponent _coin;
  late RewardComponent _reward;

  // 多重跑灯需要用到
  int _sourceLight = 0;
  int _targetLight = 0;

  // 转盘开始和结束的时间间隔
  final List<double> startTimeIntervals = [
    0.000000000001,
    0.34615384615384615,
    0.11538461538461539,
    0.23076923076923078,
    0.23076923076923078,
    0.23076923076923078,
    0.23076923076923078,
  ];

  final List<double> endTimeIntervals = [
    0.11538461538461539,
    0.11538461538461539,
    0.11538461538461539,
    0.11538461538461539,
    0.15384615384615385,
    0.15384615384615385,
    0.15384615384615385
  ];

  List<int> _existLight = [];

  final AudioPlayer _audioPlayer = AudioPlayer(); // 音频播放器
  final AudioPlayer _biu = AudioPlayer();
  final AudioPlayer _papapa = AudioPlayer();

  @override
  Future<void> onLoad() async {
    // camera =
    //     CameraComponent.withFixedResolution(width: 750, height: 1334); // 设置相机
    // 背景

    // 发送消息给服务端，获取金币
    messageService.sendMessage(ref, 1001, UserInfoArg());

    // 背景
    _background = BackgroundComponent();
    await add(_background);

    // 水果
    _frurts = FruitsComponent();
    await add(_frurts);

    //转盘
    _spin = SpinComponent(numSpin: _numOfSpin);
    await add(_spin);

    // 添加按钮
    _spinButton = SpinButtonComponent(
      onTap: _onSpinButtonPressed,
      localizedString: localizedStringSpin,
    );
    await add(_spinButton);

    // 添加赔率
    _odds = OddsComponent();
    await add(_odds);

    // 高亮显示的赔率
    _activedOdds = ActiveOddsComponent();
    await add(_activedOdds);

    // 压住显示栏
    _bets = BetsComponent(ref: ref);
    await add(_bets);

    // 切换按钮
    _switchBtn = SwitchButtonComponent(
      ref: ref,
      localizedString: localizedStringSwitch,
    );
    await add(_switchBtn);

    // 奖励
    _reward = RewardComponent(ref: ref);
    await add(_reward);

    // 金币
    _coin = CoinComponent(ref: ref);
    await add(_coin);

    // 水果按钮栏
    _fruitBtns = FruitButtonGroup(ref: ref, bets: _bets, coin: _coin);
    await add(_fruitBtns);

    // 赌大小
    _bos = BigOrSmallComponent(
        ref: ref, coin: _coin, messageService: messageService);
    await add(_bos);

    //时间
    _timer = Timer(0.1, repeat: true, onTick: _rotateSprites);
    _timer.stop();

    // 初始化跑灯和赔率位置
    _highlightSprite(_highlightedIndex);
    _hightightOdds(_oddsIndex);

    updateCoin();
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
    _oddsIndex = (_oddsIndex - 1) % 3;
    _hightightOdds(_oddsIndex);
  }

  void _rotateLight() {
    _highlightedIndex = (_highlightedIndex + 1) % _numOfSpin;
    _highlightSprite(_highlightedIndex);
  }

  // 高亮指定索引的精灵
  void _highlightSprite(int index) {
    for (int i = 0; i < _numOfSpin; i++) {
      if (index == i || _existLight.contains(i)) {
        _spin.lights[i].isVisible = true;
      } else {
        _spin.lights[i].isVisible = false;
      }
    }
  }

  void _hightightOdds(int index) {
    for (int i = 0; i < 3; i++) {
      if (i == index) {
        _activedOdds.odds[i].isVisible = true;
        _activedOdds.odds[i + 3].isVisible = true;
      } else {
        _activedOdds.odds[i].isVisible = false;
        _activedOdds.odds[i + 3].isVisible = false;
      }
    }
  }

  // ===============================================================================================================
  // 跑灯
  // 开始旋转
  // ===============================================================================================================
  void startSpinning() async {
    setButtonAvalible(false);
    _existLight = [];

    // TODO 网页音频播放出错
    // _audioSpin();

    _targetIndex = ref.read(slotMachineProvider).lights[0];

    final int gap = _targetIndex - _highlightedIndex;
    final int additionalSteps =
        (gap > 0 || gap > startTimeIntervals.length + endTimeIntervals.length)
            ? 3
            : 4;

    final int totalSteps = gap + additionalSteps * _numOfSpin;
    final int fastSteps =
        totalSteps - startTimeIntervals.length - endTimeIntervals.length;

    // 固定旋转时间
    const double spinDuration = 2.307692307692308;
    final double rotationTime = spinDuration / fastSteps;

    _timer.stop();

    // 计算总的旋转步数，确保至少转动 minRotations 圈
    final int finalSteps = totalSteps;
    int currentStep = 0;

    // 更新定时器的时间间隔
    void updateTimerInterval() {
      if (currentStep < startTimeIntervals.length) {
        _timer.stop();
        _timer =
            Timer(startTimeIntervals[currentStep], repeat: true, onTick: () {
          _rotateSprites();
          currentStep++;
          if (currentStep >= finalSteps) {
            stopSpinning();
          } else {
            updateTimerInterval();
          }
        });
        _timer.start();
      } else if (currentStep < (startTimeIntervals.length + fastSteps)) {
        _timer.stop();
        _timer = Timer(rotationTime, repeat: true, onTick: () {
          _rotateSprites();
          currentStep++;
          if (currentStep >= finalSteps) {
            stopSpinning();
          } else {
            updateTimerInterval();
          }
        });
        _timer.start();
      } else {
        _timer.stop();
        final index = currentStep - startTimeIntervals.length - fastSteps;
        _timer = Timer(endTimeIntervals[index], repeat: true, onTick: () {
          _rotateSprites();
          currentStep++;
          if (currentStep >= finalSteps) {
            stopSpinning();
          } else {
            updateTimerInterval();
          }
        });
        _timer.start();
      }
    }

    _timer = Timer(startTimeIntervals[0], repeat: true, onTick: () {
      _rotateSprites();
      currentStep++;
      if (currentStep >= finalSteps) {
        stopSpinning();
      } else {
        updateTimerInterval();
      }
    });

    _timer.start();
  }

  // 停止旋转
  void stopSpinning() {
    if (ref.read(slotMachineProvider).lights.length == 1) {
      _endSpin();
    } else {
      _targetLight = _targetIndex;
      mulSpinning();
    }
  }

  void mulSpinning() {
    List<int> lights = List.from(ref.read(slotMachineProvider).lights);
    int tempLight = lights.removeAt(0);
    _existLight.add(tempLight);

    _sourceLight = _targetLight;
    _targetLight = lights[0];
    int currentStep = 0;
    int finalSteps = 0;
    int gap = _targetLight - _sourceLight;
    finalSteps = gap < 0 ? gap + _numOfSpin : gap;
    double delay = 0.1;

    void repeatSpin() {
      _timer.stop();
      _timer = Timer(delay, repeat: true, onTick: () {
        _rotateLight();
        currentStep++;

        if (currentStep < finalSteps) {
          delay = 0.02;

          repeatSpin();
        } else {
          delay = 0.6;
          tempLight = lights.removeAt(0);
          _existLight.add(tempLight);

          if (lights.isEmpty) {
            // TODO 网页音频播放出错
            // _audioPa();
            _endSpin();
          } else {
            // TODO 网页音频播放出错
            // _audioBiu();
            _sourceLight = _targetLight;
            _targetLight = lights[0];
            gap = _targetLight - _sourceLight;
            finalSteps = gap < 0 ? gap + _numOfSpin : gap;
            currentStep = 0;
            repeatSpin();
          }
        }
      });
      _timer.start();
    }

    _timer.stop();
    _timer = Timer(0.6, repeat: true, onTick: repeatSpin);
    _timer.start();

    _audioBiu();
  }

  void _endSpin() {
    ref.read(slotMachineProvider).setIsSpinning(false);
    _timer.stop();
    setButtonAvalible(true);
    updateCoin();
    updateReward();
  }

  // ===============================================================================================================
  // 赌大小
  // ===============================================================================================================

  void startBOS() {
    updateCoin();
    updateReward();
  }

  void _audioSpin() async {
    await _audioPlayer.seek(Duration.zero);
    _audioPlayer.play();
  }

  void _audioBiu() async {
    await _biu.seek(Duration.zero);
    _biu.play();
  }

  void _audioPa() async {
    await _papapa.seek(Duration.zero);
    _papapa.play();
  }

  void setButtonAvalible(bool isEnabled) {
    _spinButton.setEnabled(isEnabled);
    _fruitBtns.setEnabled(isEnabled);
    _bos.setEnabled(isEnabled);
  }

  void _onSpinButtonPressed() {
    final bets = ref.read(slotMachineProvider).bets;
    final amount = ref.read(slotMachineProvider).getBets();
    final c = ref.read(slotMachineProvider).coin;

    if (amount > 0) {
      if (c >= amount) {
        messageService.sendMessage(
            ref, 2001, FruitPlayArg(flag: '0', fruits: bets));
        ref.read(slotMachineProvider).setCoin(c - amount);
        updateCoin();
      }
    }
  }

  void updateCoin() {
    _coin.updateLabel();
  }

  void updateReward() {
    _reward.updateLabel();
  }
}
