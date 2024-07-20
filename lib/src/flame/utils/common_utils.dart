import 'package:flame/components.dart';
import 'package:flame/flame.dart';

// import '../component/common/lable.dart';

Future<Sprite> loadSprite(String path) async {
  return await Flame.images.load(path).then((image) => Sprite(image));
}

// 设置精灵和框架的位置
void linePosition(
    List<PositionComponent> componets, Vector2 oddsSize, Vector2 screenSize) {
  const double spacing = 2;
  final totalWidth =
      componets.length * oddsSize.x + (componets.length - 1) * spacing;

  final startX = (screenSize.x - totalWidth) / 2;

  for (int i = 0; i < componets.length; i++) {
    componets[i].x = startX + i * (oddsSize.x + spacing);
  }
}
